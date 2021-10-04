*** Settings ***
Library    RPA.Browser.Playwright    enable_playwright_debug=False
Library    RPA.Tables
Library    RPA.HTTP
Library    RPA.PDF
Library    RPA.Archive
Library    RPA.RobotLogListener
Library    RPA.Robocorp.Vault
Library    RPA.Dialogs

Library    Collections
Library    String
Variables    ./resources/RSBI_locators.py

*** Keywords ***

Initialize Browser
    [Documentation]    Start Browser With Desided Configurations
    [Arguments]    ${headless}    ${chrome_options_arguments}
    RPA.Browser.Playwright.New Browser    chromium    headless=${headless}    args=${chrome_options_arguments}
    RPA.Browser.Playwright.New Context    acceptDownloads=${True}


Open Web Page
    [Arguments]    ${url}
    RPA.Browser.Playwright.New Page    ${url}


Get Robot Orders
    [Documentation]    Read secret URL from vault.json and download the orders file into the given location
    [Arguments]    ${dl_target}    ${url}
    ${file}=    RPA.HTTP.Download    url=${url}
    ...         target_file=${dl_target}    overwrite=True    stream=${False}


Fill Robot Order Form
    [Documentation]    Fill the order form
    [Arguments]    ${order}
    # Close greeting pop-up
    ${popup}=    Run Keyword And Return Status    RPA.Browser.Playwright.Wait For Elements State    ${elem_label_popup_rights}
    Run Keyword If    "${popup}" == "${True}"
    ...    RPA.Browser.Playwright.Click    ${elem_btn_popup_rights_ok}
    # Select the head
    RPA.Browser.Playwright.Select Options By    ${elem_dropdown_head}    value    ${order}[Head]
    # Select the body
    ${body_selection}=    String.Format String    ${elem_radio_value}    value=${order}[Body]
    RPA.Browser.Playwright.Click    ${body_selection}
    # Apply legs
    RPA.Browser.Playwright.Fill Text    ${elem_txtbox_legs}    ${order}[Legs]
    # Apply address
    RPA.Browser.Playwright.Fill Text    ${elem_txtbox_address}    ${order}[Address]


Submit Robot Order Get Receipt
    [Documentation]    Submit order and get the receipt if successful
    [Arguments]    ${order_no}
    RPA.Browser.Playwright.Click    ${elem_btn_preview}
    Sleep    2s
    RPA.Browser.Playwright.Click    ${elem_btn_order}

    ${warning_visible}=    RPA.Browser.Playwright.Get Element State    ${elem_label_warning}    visible
    Run Keyword If    "${warning_visible}" == "${True}"
    ...    Fail    Whoops, got a warning!

    RPA.Browser.Playwright.Wait For Elements State   ${elem_label_receipt}    visible    5s

    # Getting as text and shaping it afterwards as desired.
    # Had issues with Playwright's Get Attribute KW
    ${receipt_txt}=    RPA.Browser.Playwright.Get Text    ${elem_label_receipt}

    ${robot_img}=    RPA.Browser.Playwright.Take Screenshot
    ...    ${OUTPUTDIR}/robot_images/${order_no}    ${elem_img_robot}

    ${success}=    Set Variable    ${True}
    [Return]    ${receipt_txt}    ${robot_img}    ${success}


Create Pdf Receipt
    [Documentation]    Save receipt content as .pdf
    [Arguments]    ${receipt_name}    ${txt}    ${img}

    #Add HTML line breaks tags to text
    ${html_txt}=    String.Replace String    ${txt}    \n    <br>

    RPA.PDF.HTML To PDF    ${html_txt}    ${OUTPUTDIR}${/}receipts${/}${receipt_name}.pdf
    RPA.PDF.Add Watermark Image To Pdf
    ...    image_path=${img}
    ...    source_path=${OUTPUTDIR}${/}receipts${/}${receipt_name}.pdf
    ...    output_path=${OUTPUTDIR}${/}receipts${/}${receipt_name}.pdf

    RPA.PDF.Close PDF    ${CURDIR}${/}output${/}receipts${/}${receipt_name}.pdf


Create Zip File
    [Documentation]    Create .zip package
    [Arguments]    ${file}    ${zip_name}
    RPA.Archive.Archive Folder With Zip    ${file}   ${zip_name}


Get Secret From Vault
    [Documentation]    Fetch secrets from vault
    [Arguments]    ${secret_name}
    Log    Getting secrets from vault
    ${secrets}=    RPA.Robocorp.Vault.Get Secret    ${secret_name}
    [Return]     ${secrets}
