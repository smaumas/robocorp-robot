*** Settings ***
Documentation   Test robot for ordering robots from robotsparebinindustries.com.
...             Order receipts are saved as PDF, containing screenshot of the order.
...             Receipts are archived as .zip file.
Variables       resources/settings.py
Resource        keywords.robot
Resource        keywords_dialog.robot


*** Tasks ***
Download Orders File
    [Tags]    step_1
    [Documentation]    Ask for orders url and download the file
    ${url_orders}=    Dialog - Ask for Url
    Get Robot Orders    ${downloads_target}    ${url_orders}

Go To RSBI Page And Place Orders
    [Tags]    step_2
    [Documentation]    Go to RSBI page and submit orders according to the orders file
    ${secret_urls}=    Get Secret From Vault    urls
    Initialize Browser    False    ${chrome_options_arguments}
    Open Web Page    ${secret_urls}[url_rsbi]
    @{orders}=    Read table from CSV    path=${downloads_target}\orders.csv    header=${True}

    FOR    ${row}    IN    @{orders}
        ${order_success}=    Set Variable    ${None}
        Fill Robot Order Form    ${row}

        ${receipt_txt}    ${robot_img}    ${order_success}=    Run Keyword And Continue On Failure
        ...    Wait Until Keyword Succeeds    100x    1s    Submit Robot Order Get Receipt    ${row}[Order number]

        Run Keyword If    ${order_success}
        ...    Run Keywords
            ...    Create Pdf Receipt    ${row}[Order number]    ${receipt_txt}    ${robot_img}
            ...    AND    
            ...    Click    ${elem_btn_orderAnother}
        ...    ELSE
        ...    Log    Warning, order had to be skipped due target system failure    WARN    

    END

Pack Order Receipts To Zip
    [Tags]    step_3
    [Documentation]
    Create Zip File    ${CURDIR}${/}output${/}receipts    ${CURDIR}${/}output${/}receipts.zip
