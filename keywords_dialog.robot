*** Settings ***
Library    RPA.Dialogs

Library    Collections
Library    String

*** Keywords ***
Dialog - Ask for Url
    Add heading    Please provide an url to the orders.csv
    Add text input    input_url    label=url    placeholder=Enter url here
    ${response}=    Run dialog
    [Return]    ${response.input_url}