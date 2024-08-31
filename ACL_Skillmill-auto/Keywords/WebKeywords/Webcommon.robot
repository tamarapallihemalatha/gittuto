*** Settings ***
Resource          ../../Global/super.robot

*** Keywords ***
Launch Browser
    [Arguments]    ${browser_name}    ${url}
    Run Keyword If    '${browser_name}'=='Chrome' or '${browser_name}'=='chrome' or '${browser_name}'=='gc'    Open Browser    ${url}    gc
    Run Keyword If    '${browser_name}'=='Firefox' or '${browser_name}'=='firefox' or '${browser_name}'=='ff'    Open Browser    ${url}    Firefox

Launch Browser and Navigate to URL
    [Arguments]    ${url}    ${browser_name}
    Launch Browser    ${browser_name}    ${url}
    Maximize Browser Window
    Wait Until Time    2

Read TestData From Excel
    [Arguments]    ${testcaseid}    ${sheet_name}
    [Documentation]    Read TestData from excel file for required data.
    ...
    ...    Example:
    ...    Read TestData From Excel TC_01 SheetName
    ${test_data}    CustomLibrary.Get Ms Excel Row Values Into Dictionary Based On Key    ${TESTDATA_FOLDER}/TestData.xlsx    ${testcaseid}    ${sheet_name}
    Set Global Variable    ${test_data}
    [Return]    ${test_data}

Take Screenshot
    Capture Page Screenshot

Set Browser Position
    [Arguments]    ${browser_name}
    Run Keyword If    '${browser_name}'=='Chrome' or '${browser_name}'=='chrome' or '${browser_name}'=='gc'    Set Window Position    0    5
    Run Keyword If    '${browser_name}'=='Firefox' or '${browser_name}'=='firefox' or '${browser_name}'=='ff'    Set Window Position    1005    6
    Set Window Size    959    1047

Create Screenshot Directory
    Run Keyword And Ignore Error    Create Directory    ${EXECDIR}/Screenshots
    SeleniumLibrary.Set Screenshot Directory    ${EXECDIR}/Screenshots

Login To Application
    [Arguments]    ${user_name}    ${password}
    Launch Browser and Navigate to URL    ${URL}    ${BROWSER_NAME}
    Wait Until Time    2
    Wait Until Element Is Visible    ${textbox.login.emailid}    ${LONG_WAIT}    Login page is not opened
    Input Text    ${textbox.login.emailid}    ${user_name}
    Input Text    ${textbox.login.password}    ${password}
    Click Button    ${button.loginpage.loginbutton}
    Set Test Message    Successfully log in to the Profile page.
    Wait Until Element Is Visible    ${label.login.profilepageheading}    ${SHORT_WAIT}    Login failed.Skillmill page is not displayed
    Set Test Message    successfully navigated into the Profile page

Wait Until Element Clickable and Click
    [Arguments]    ${locator}    ${time_interval}=2s
    Wait Until Keyword Succeeds    14s    ${time_interval}    Click Element    ${locator}

Fail And Take Screenshot
    [Arguments]    ${error_message}
    Run Keyword And Continue On Failure    Fail    ${error_message}
    Take Screenshot

Create Directories
    Create Screenshot Directory

Validate Error Message
    [Arguments]    ${message}
    cc    //div[text()='${message}']    ${MEDIUM_WAIT}    '${message}' is not visible after waiting ${MEDIUM_WAIT}
    ${status}    Run Keyword And Return Status    SeleniumLibrary.Page Should Contain    ${message}
    Run Keyword If    '${status}'=='True'    log    '${message}' Message is displayed
    ...    ELSE    Fail    '${message}' is not displayed

Enter Details in JoinUs Page
    [Arguments]    ${details}
    Run Keyword If    '${details}[First Name]'!='None'    Input Text    ${textbox.joinus.firstname}    ${details}[First Name]
    Run Keyword If    '${details}[Last Name]'!='None'    Input Text    ${textbox.joinus.lastname}    ${details}[Last Name]
    Run Keyword If    '${details}[Email]'!='None'    Input Text    ${textbox.joinus.email}    ${details}[Email]
    Run Keyword If    '${details}[Password]'!='None'    Input Text    ${textbox.joinus.pwd}    ${details}[Password]
    Run Keyword If    '${details}[Confirm-Password]'!='None'    Input Text    ${textbox.joinus.confirmpwd}    ${details}[Confirm-Password]
    Run Keyword If    '${details}[Mobile Number]'!='None'    Input Text    ${textbox.joinus.phnnumber}    ${details}[Mobile Number]
    Select Radio Button    gender    Female
    Click Element    ${button.login.profilepage.accountsettingspage.submit}

Validate Fields in Account Settings Page
    [Arguments]    ${pageheading}    ${value}    ${grid_list}
    [Documentation]    Description: Validate Fields in Account Settings Page
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Designed date: 20-07-2023
    @{grid_list}    Split String    ${grid_list}    |
    SeleniumLibrary.Wait Until Element Is Visible    //p[text()="${pageheading}"]    ${SHORT_WAIT}    Account Settings Page is not displayed after waiting for ${SHORT_WAIT}
    Comment    Run Keyword If    '${value}'=='Subscription Plan Details'    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.profilepage.selectsubscriptionplan.subscriptionplanheading}    ${SHORT_WAIT}    Subscription Plan Details Page is not displayed after waiting for ${SHORT_WAIT}
    FOR    ${key}    IN    @{grid_list}
        Run Keyword If    '${value}'=='Account Settings'    SeleniumLibrary.Element Should Be Visible    //label[text()[normalize-space()="${key}"]]
        Run Keyword If    '${value}'=='Account Settings'    Set Test Message    Full Name,Email and Phone Number are displayed
        Run Keyword If    '${value}'=='Subscription Plan Details'    SeleniumLibrary.Element Should Be Visible    //p[text()[normalize-space()="${key}"]]
        Run Keyword If    '${value}'=='Purchase History'    SeleniumLibrary.Element Should Be Visible    //th[text()="${key}"]
        Run Keyword If    '${value}'=='Purchase History'    Set Test Message    Under Purchase History Start Date,End Date,Status,Total and PAYMENT Type is Visible
        Run Keyword If    '${value}'=='Change Password'    SeleniumLibrary.Element Should Be Visible    //label[text()[normalize-space()="${key}"]]
        Run Keyword If    '${value}'=='Change Password'    Set Test Message    Current password, New password, Confirm Password are displayed
    END

Enter Login Details
    [Arguments]    ${details}
    [Documentation]    Description: Modify the Account Setting Details
    ...
    ...    Author Name: Kancherl Ramya
    ...
    ...    Designed Date: 24-07-2023
    Wait Until Time    5
    Run Keyword If    '${details}[Email Id]'!='None'    Input Text    ${textbox.login.emailid}    ${details}[Email Id]
    Run Keyword If    '${details}[Password]'!='None'    Input Text    ${textbox.login.password}    ${details}[Password]
    Click Button    ${button.loginpage.loginbutton}

Validate Success or Error Message
    [Arguments]    ${message}
    [Documentation]    Description: Modify the Account Setting Details
    ...
    ...    Author Name: Kancherl Ramya
    ...
    ...    Designed Date: 24-07-2023
    ${status}    Run Keyword And Return Status    Wait Until Page Contains    ${message}    ${SHORT_WAIT}
    Run Keyword If    ${status}==True    log    ${message} Message is Displayed
    ...    ELSE    Fail And Take Screenshot    ${message} Message is not displayed

Validate and Click Logout Button and Sub Modules for Profile Page
    [Arguments]    ${value}    ${sub_module_name}=None
    [Documentation]    Description: Validate Logout Button for Profile Page.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 24-07-2023
    Run Keyword If    '${value}'=='Logout'    Wait Until Element Is Visible    ${link.login.profilepage.logout}    ${SHORT_WAIT}    Log Out Button is not Visible after waiting for${SHORT_WAIT} seconds
    Run Keyword If    '${value}'=='Logout'    SeleniumLibrary.Click Element    ${link.login.profilepage.logout}
    Run Keyword If    '${value}'=='Logout'    Set Test Message    successfully logged out of the Profile page.
    Run Keyword If    '${value}'=='Profile Page'    Wait Until Element Is Visible    //span[text()[normalize-space()="${sub_module_name}"]]    ${LONG_WAIT}    Account Setting sub module is not visible after waiting for ${LONG_WAIT} seconds
    Run Keyword If    '${value}'=='Profile Page'    SeleniumLibrary.Click Element    //span[text()[normalize-space()="${sub_module_name}"]]

Modify the Account Setting Details
    [Arguments]    ${value}=None    ${fullname}=None    ${phonenum}=None
    [Documentation]    Description: Modify the Account Setting Details
    ...
    ...    Author Name: Kancherl Ramya
    ...
    ...    Designed Date: 24-07-2023
    Run Keyword If    '${value}'=='Empty Full Name'    Wait Until Element Is Visible    ${textbox.login.profilepage.accountsettingspage.fullname}    ${MEDIUM_WAIT}    Full name is not visible after waiting for ${MEDIUM_WAIT} seconds
    Run Keyword If    '${value}'=='Empty Full Name'    SeleniumLibrary.Click Element    ${textbox.login.profilepage.accountsettingspage.fullname}
    Run Keyword If    '${value}'=='Empty Full Name'    press keys    ${textbox.login.profilepage.accountsettingspage.fullname}    CTRL+a+BACKSPACE
    Run Keyword If    '${fullname}'!='None'    SeleniumLibrary.Input Text    ${textbox.login.profilepage.accountsettingspage.fullname}    ${fullname}
    Run Keyword If    '${value}'=='Empty Full Name'    Mouse Over    ${textbox.login.profilepage.accountsettingspage.fullname}
    Run Keyword If    '${value}'=='Empty Phone Num'    Wait Until Element Is Visible    ${textbox.login.profilepage.accountsettings.phonenumber}    ${MEDIUM_WAIT}    Phone Number is not visible after waiting for ${MEDIUM_WAIT} seconds
    Run Keyword If    '${value}'=='Empty Phone Num'    SeleniumLibrary.Click Element    ${textbox.login.profilepage.accountsettings.phonenumber}
    Run Keyword If    '${value}'=='Empty Phone Num'    press keys    ${textbox.login.profilepage.accountsettings.phonenumber}    CTRL+a+BACKSPACE
    Run Keyword If    '${phonenum}'!='None'    SeleniumLibrary.Input Text    ${textbox.login.profilepage.accountsettings.phonenumber}    ${phonenum}
    Run Keyword If    '${value}'=='Empty Phone Num'    Mouse Over    ${textbox.login.profilepage.accountsettings.phonenumber}
    Run Keyword If    '${value}'=='Phone Number'    Mouse Over    ${textbox.login.profilepage.accountsettings.phonenumber}
    Wait Until Time    1
    ${selected_msg}    Run Keyword If    '${value}'=='Empty Full Name'    Get Element Attribute    ${textbox.login.profilepage.accountsettingspage.fullname}    validationMessage
    Run Keyword If    '${value}'=='Empty Full Name'    Should Be Equal    ${selected_msg}    Please fill in this field.
    ${selected_msg}    Run Keyword If    '${value}'=='Empty Phone Num'    Get Element Attribute    ${textbox.login.profilepage.accountsettings.phonenumber}    validationMessage
    Run Keyword If    '${value}'=='Empty Phone Num'    Should Be Equal    ${selected_msg}    Please fill in this field.
    ${selected_msg}    Run Keyword If    '${value}'=='Phone Number'    Get Element Attribute    ${textbox.login.profilepage.accountsettings.phonenumber}    validationMessage
    Run Keyword If    '${value}'=='Phone Number'    Should Be Equal    ${selected_msg}    Please match the format requested.
    Click Element    ${button.login.profilepage.accountsettingspage.submit}

Validate Handle Alert Confirmation for Account Settings Page
    [Documentation]    Description: Modify the Account Setting Details
    ...
    ...    Author Name: Kancherl Ramya
    ...
    ...    Designed Date: 24-07-2023
    Handle Alert    ACCEPT
    Wait Until Time    2
    Handle Alert    ACCEPT
    Wait Until Time    2

Close Browser
    SeleniumLibrary.Close All Browsers

Validate Home Page of ACL
    [Documentation]    Description: Validating the home screen option \ button
    ...
    ...    Author Name: Hemalatha
    ...
    ...    Designed Date: 25-07-2023
    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.homepage}    ${SHORT_WAIT}    Home page is visible after waiting ${SHORT_WAIT}
    SeleniumLibrary.Wait Until Element Is Visible    ${button.home.aboutus}    ${SHORT_WAIT}    Home page is visible after waiting ${SHORT_WAIT}
    SeleniumLibrary.Click Element    ${button.home.aboutus}
    Element Should Be Visible    ${label.url.home.aboutus}
    SeleniumLibrary.Click Element    ${button.home.service}
    Element Should Be Visible    ${label.home.services.ourservice}
    SeleniumLibrary.Click Element    ${button.home.product}
    Element Should Be Visible    ${label.home.products.ourproducts}
    SeleniumLibrary.Click Element    ${button.home.keyperson}
    Element Should Be Visible    ${label.home.keyperson.ourteam}
    SeleniumLibrary.Click Element    ${button.home.contactus}
    Element Should Be Visible    ${label.home.contactus.contact}

Validate JoinUs and Individual Button
    [Arguments]    ${button}=None
    [Documentation]    Description: Validating the Joinus and individual button
    ...
    ...    Author Name: Hemalatha
    ...
    ...    Designed Date: 25-07-2023
    SeleniumLibrary.Wait Until Element Is Visible    ${button.url.joinus}    ${SHORT_WAIT}    Join Us is not visible after waiting ${SHORT_WAIT}
    SeleniumLibrary.Click Element    ${button.url.joinus}
    Element Should Be Visible    ${label.aclskillmill.clickjoinus.joinus}
    Element Should Be Visible    ${label.aclskillmill.clickjoinus.joinus}
    Run Keyword If    '${button}'=="Individual"    SeleniumLibrary.Wait Until Element Is Visible    ${button.url.joinus.individual}    ${SHORT_WAIT}    Individual button is not visible after waiting ${SHORT_WAIT}
    Run Keyword If    '${button}'=="Individual"    Log    Individual Button is displayed

Validate Test Screen Options and Templates
    [Arguments]    ${test}=None    ${test1}=None    ${test2}=None    ${test3}=None
    [Documentation]    Description: This keyword used to validate already created template with questions count and timer in test screen
    ...
    ...    Author Name: Hemalatha
    ...
    ...    Designed Date: 07-08-2023
    Wait Until Keyword Succeeds    10s    2s    Element Should Be Visible    ${label.url.test}
    Log    Test option displayed in menu
    SeleniumLibrary.Click Element    ${label.url.test}
    Run Keyword If    '${test}'=="No Template"    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.test.notemplate}    ${LONG_WAIT}    No Template Message is not visible after waiting ${LONG_WAIT}
    ${test}    Run Keyword If    '${test}'=="No Template"    Get Text    ${label.url.test.notemplate}
    Run Keyword If    '${test}'=="No Template"    Log    ${test} is displayed for new user
    Run Keyword If    '${test1}'=="Template"    Wait Until Keyword Succeeds    8s    2s    Element Should Be Visible    ${label.url.test.customoption}
    Run Keyword If    '${test1}'=="Template"    Wait Until Keyword Succeeds    8s    2s    Element Should Be Visible    ${label.url.test.standardoption}
    Run Keyword If    '${test2}'=="Create Template"    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.test.customtest}    ${SHORT_WAIT}    Custom test is not visible after waitng ${SHORT_WAIT}
    Run Keyword If    '${test3}'=="Standard Test"    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.test.standardoption}    ${LONG_WAIT}    Standard Option is not visible after waiting ${LONG_WAIT}
    Run Keyword If    '${test3}'=="Standard Test"    Click Element    ${label.url.test.standardoption}
    ${templatename}    Run Keyword If    '${test2}'=="Create Template"    Get Text    ${label.url.test.templatename}
    ${qns}    Run Keyword If    '${test2}'=="Create Template"    Get Text    ${label.url.test.templtenaname.qns}
    ${timer}    Run Keyword If    '${test2}'=="Create Template"    Get Text    ${label.url.test.templatename.timer}
    Run Keyword If    '${test2}'=="Create Template"    Log    ${templatename},${qns} and ${timer} are displayed in test custom screen

Click and Validate Disclaimer Page
    [Arguments]    ${back}=None    ${start}=None    ${submit}=None    ${start1}=None    ${start2}=None    ${submitpage}=None    ${back1}=None
    [Documentation]    Description: Validating the disclaimer page details with buttons
    ...
    ...    Author Name: Hemalatha
    ...
    ...    Designed Date: 07-08-2023
    Wait Until Keyword Succeeds    10s    2s    Element Should Be Visible    ${label.url.test}
    Log    Test option displayed in menu
    SeleniumLibrary.Click Element    ${label.url.test}
    Run Keyword If    '${start1}'=="Standard Test"    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    ${label.url.test.standardoption}
    Run Keyword If    '${start1}'=="Standard Test"    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    ${icon.url.test.tempname.greatericon}
    Run Keyword If    '${start1}'=="Custom Test"    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    //*[local-name()="p"][@class="text" and not(contains(.,"0 Questions"))]//following-sibling::p[@class="timer"]/../../..//i[@class="fi fi-sr-angle-small-right arrowicon"]
    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.test.tname.disclaimer}    ${LONG_WAIT}    Disclaimar page is not visible after waiting ${LONG_WAIT} seconds
    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.test.tname.disclaimer.instructions}    ${SHORT_WAIT}    Instructions: is not visible after waiting ${SHORT_WAIT}
    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.test.tname.disclaimer.liabilities}    ${SHORT_WAIT}    Liability Disclaimer is not visible after waiting ${SHORT_WAIT}
    Wait Until Keyword Succeeds    10s    2s    Element Should Be Visible    ${button.login.test.tname.disclaimer.back}
    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.test.tname.dc.start}    ${SHORT_WAIT}    Start Button is not visible after waiting ${SHORT_WAIT}
    Run Keyword If    '${back}'=="Back Page"    Wait Until Keyword Succeeds    8s    2s    Click Element    ${button.login.test.tname.disclaimer.back}
    Run Keyword If    '${back}'=="Back Page"    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.test.customtest}    ${MEDIUM_WAIT}
    Run Keyword If    '${back}'=="Back Page"    Log    Custom Test page is visible
    Run Keyword If    '${start}'=="Start Test"    SeleniumLibrary.Click Element    ${button.login.test.tname.dc.start}
    Comment    Run Keyword If    '${start}'=="Start Test"    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.starttest.timer}    ${SHORT_WAIT}    Test Timer is not visible after waiting ${SHORT_WAIT}
    Run Keyword If    '${submit}'=="Start Exam"    Click Element    ${button.login.test.tname.disclaimer.back}
    Run Keyword If    '${submit}'=="Start Exam"    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    ${icon.url.test.tempname.greatericon}
    Run Keyword If    '${submit}'=="Start Exam"    Wait Until Keyword Succeeds    8s    2s    Click Element    ${button.login.test.tname.dc.start}
    Run Keyword If    '${submit}'=="Start Exam"    Log    Test Page is Displayed
    Run Keyword If    '${start2}'=="Standard Test1"    Wait Until Keyword Succeeds    8s    2s    Click Element    ${button.login.test.tname.disclaimer.back}
    Run Keyword If    '${start2}'=="Standard Test1"    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.test.standard.teststandard}    ${MEDIUM_WAIT}
    Run Keyword If    '${start2}'=="Standard Test1"    Log    Test Standard page is visible
    Run Keyword If    '${submitpage}'=="Exam Page"    Log    Standard Exam page is visible
    Run Keyword If    '${back1}'=="Standard Back Page"    Wait Until Keyword Succeeds    8s    2s    Click Element    ${button.login.test.tname.disclaimer.back}
    Run Keyword If    '${back1}'=="Standard Back Page"    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.test.standard.teststandard}    ${MEDIUM_WAIT}
    Run Keyword If    '${back1}'=="Standard Back Page"    Log    Custom Test page is visible

Enter JoinUs Complete Details
    [Arguments]    ${firstname}    ${lastname}    ${email}    ${pwd}    ${cnfmpwd}    ${phnnum}
    Input Text    ${textbox.joinus.firstname}    ${firstname}
    Input Text    ${textbox.joinus.lastname}    ${lastname}
    Input Text    ${textbox.joinus.email}    ${email}
    ${email1}    Set Variable    ${email}
    Input Text    ${textbox.joinus.pwd}    ${pwd}
    ${pwd1}    Set Variable    ${pwd}
    Input Text    ${textbox.joinus.confirmpwd}    ${cnfmpwd}
    Input Text    ${textbox.joinus.phnnumber}    ${phnnum}
    Select Radio Button    gender    Female
    Click Element    ${button.login.profilepage.accountsettingspage.submit}
    Wait Until Time    2
    Wait Until Element Is Visible    ${textbox.login.emailid}    ${LONG_WAIT}    Login page is not opened
    Input Text    ${textbox.login.emailid}    ${email1}
    Input Text    ${textbox.login.password}    ${pwd1}
    Click Button    ${button.loginpage.loginbutton}
    Set Test Message    Successfully log in to the Profile page.
    Wait Until Element Is Visible    ${label.login.profilepageheading}    ${SHORT_WAIT}    Login failed.Skillmill page is not displayed
    Set Test Message    successfully navigated into the Profile page
    [Return]    ${email1}    ${pwd1}

Click and Validate Question in Test Screen
    [Arguments]    ${single}=None    ${single1}=None    ${qns}=None    ${submit}=None    ${submit1}=None    ${submit2}=None
    [Documentation]    Description: This keyword is used to validate the single and multiple questions with submit button
    ...
    ...    Author Name: Hemalatha
    ...
    ...    Designed Date: 07-08-2023
    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.test.tname.disclaimer.start.singlebutton}    ${MEDIUM_WAIT}
    Run Keyword If    '${single}'=="SingleOption"    Click Element    ${button.login.test.tname.disclaimer.start.singlebutton}
    Run Keyword If    '${single1}'=="MultipleOption"    Click Element    ${button.login.test.tname.disclaimer.start.radio}
    Run Keyword If    '${single1}'=="MultipleOption"    Log    User can select any one option in a question
    Run Keyword If    '${qns}'=="Multipleqns"    Click Element    ${button.login.test.radio2}
    Run Keyword If    '${qns}'=="Multipleqns"    Click Element    ${button.login.test.disclaimer.button3}
    Run Keyword If    '${qns}'=="Multipleqns"    Click Element    ${button.login.test.disclaimer.radio4}
    Run Keyword If    '${qns}'=="Multipleqns"    Click Element    ${button.login.test.disclaimer.radio5}
    Run Keyword If    '${submit}'=="Submit"    Scroll To Element    ${button.login.test.startest.submit}
    Run Keyword If    '${submit}'=="Submit"    Click Element    ${button.login.test.startest.submit}
    Run Keyword If    '${single}'=="SingleOption"    Click Element    //button[text()="Result"]
    Run Keyword If    '${single}'=="SingleOption"    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.test.submit.viewreport.resultdetails table}    ${SHORT_WAIT}    Result submitted table is not visible after waiting ${SHORT_WAIT}
    Run Keyword If    '${submit1}'=="Submit1"    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.submit.test.viewreport}    ${SHORT_WAIT}    View Report is not visible after waitng ${SHORT_WAIT}
    Run Keyword If    '${submit1}'=="Submit1"    Log    View Report is visible after submiting the test
    ${marks}    Run Keyword If    '${submit1}'=="Submit1"    Get Text    ${label.login.submit.viewreport.marks}
    Run Keyword If    '${submit1}'=="Submit1"    Log    ${marks} are displayed
    Run Keyword If    '${submit2}'=="Submit2"    SeleniumLibrary.Wait Until Element Is Visible    ${labels.login.submit test.answer}    ${SHORT_WAIT}    Answers is not visible after waiting ${SHORT_WAIT}
    Run Keyword If    '${submit2}'=="Submit2"    Click Element    ${labels.login.submit test.answer}
    ${answers}    Run Keyword If    '${submit2}'=="Submit2"    Get Text    ${label.login.submit test.answer.question}
    Run Keyword If    '${submit2}'=="Submit2"    Log    ${answers} are displayed

Validate Subscribe Plan Radio Button
    [Arguments]    ${group_name}    ${plan_name}
    [Documentation]    Description: Validate Subscribe Plan Radio Button.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 04-Aug-2023
    Wait Until Element Is Visible    (//input[@name="validity"])[1]    ${MEDIUM_WAIT}    Radio Button is not visible after waiting for ${MEDIUM_WAIT}
    Select Radio Button    ${group_name}    ${plan_name}
    Radio Button Should Be Set To    ${group_name}    ${plan_name}
    Set Test Message    ${plan_name} Radio Button Selected

Wait Until Element Clickable and Click
    [Arguments]    ${locator}    ${time_interval}=2s
    [Documentation]    Description: Wait Until Element Clickable and Click.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 04-Agu-2023
    Wait Until Keyword Succeeds    14s    ${time_interval}    Javascript Click By Xpath    ${locator}

Click and Validate Add and Delete Button
    [Arguments]    ${value}=None
    [Documentation]    Description: Click on add button.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 07-Aug-2023
    Run Keyword If    '${value}'=='Template List Add'    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.profilepage.createtemplate.templatelistadd}    ${LONG_WAIT}    Add is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${value}'=='Template List Add'    SeleniumLibrary.Click Element    ${button.login.profilepage.createtemplate.templatelistadd}
    Run Keyword If    '${value}'=='Template List Delete'    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.profilepage.createtemplate.delete}    ${LONG_WAIT}    Delete Button is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${value}'=='Template List Delete'    SeleniumLibrary.Click Element    ${button.login.profilepage.createtemplate.delete}
    Run Keyword If    '${value}'=='Template List Delete'    Set Test Message    Successfully Deleted Selected Check Boxes

Validate Add Template Page Details
    [Arguments]    ${value}    ${grid_list}
    [Documentation]    Description: Validate Add Template Page Details.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 07-Agu-2023
    @{grid_list}    Split String    ${grid_list}    |
    FOR    ${key}    IN    @{grid_list}
        Run Keyword If    '${value}'=='Subjects'    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectionsubjects}
        Run Keyword If    '${value}'=='Subjects'    SeleniumLibrary.Element Should Be Visible    //option[text()[normalize-space()="${key}"]]
        Run Keyword If    '${value}'=='Subjects'    Set Test Message    All Subjects is displayed
        Run Keyword If    '${value}'=='Subjects'    SeleniumLibrary.Click Element    //option[text()[normalize-space()="${key}"]]
        Run Keyword If    '${value}'=='Subjects'    SeleniumLibrary.Unselect Frame
        Run Keyword If    '${value}'=='Topics'    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectiontopics}
        Run Keyword If    '${value}'=='Topics'    SeleniumLibrary.Element Should Be Visible    (//a[text()="${key}"])[1]
        Run Keyword If    '${value}'=='Topics'    Set Test Message    Topics is displayed
        Comment    Run Keyword If    '${value}'=='Topics'    SeleniumLibrary.Click Element    (//a[text()="${key}"])[1]
        Run Keyword If    '${value}'=='Topics'    SeleniumLibrary.Unselect Frame
        Run Keyword If    '${value}'=='Levels'    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectionlevels}
        Run Keyword If    '${value}'=='Levels'    SeleniumLibrary.Element Should Be Visible    //p[text()="${key}"]
        Run Keyword If    '${value}'=='Levels'    Set Test Message    Levels is displayed
        Run Keyword If    '${value}'=='Levels'    SeleniumLibrary.Unselect Frame
    END

Validate Elements in Create Template
    [Arguments]    ${element}
    [Documentation]    Description: Validate Buttons.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 07-Aug-2023
    Run Keyword If    '${element}'=='Navigate Back Before Submit'    Go Back
    Run Keyword If    '${element}'=='Navigate Back After Submit'    Go Back
    Run Keyword If    '${element}'=='Navigate Back After Submit'    Handle Alert    ACCEPT
    Wait Until Time    3
    Run Keyword If    '${element}'=='Create Template Add and Save'    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectionlevels}
    Run Keyword If    '${element}'=='Create Template Add and Save'    Wait Until Element Is Visible    ${link.login.profilepage.createtemplate.addtemplatelist.add}    ${MEDIUM_WAIT}    Add button is not visible after waiting ${MEDIUM_WAIT}
    Run Keyword If    '${element}'=='Create Template Add and Save'    Wait Until Element Is Visible    ${button.login.profilepage.createtemplate.addtemplatelist.save}    ${MEDIUM_WAIT}    Save button is not visible after waiting ${MEDIUM_WAIT}
    Run Keyword If    '${element}'=='Create Template Add and Save'    SeleniumLibrary.Unselect Frame
    Run Keyword If    '${element}'=='Template List add'    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.profilepage.createtemplate.templatelistadd}    ${MEDIUM_WAIT}    Add button is not visible after waiting ${MEDIUM_WAIT} seconds
    Run Keyword If    '${element}'=='Template List Delete'    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.profilepage.createtemplate.delete}    ${MEDIUM_WAIT}    Delete button is not visible after waiting ${MEDIUM_WAIT} seconds
    Run Keyword If    '${element}'=='Pay Button'    Wait Until Element Is Visible    ${button.login.profilepage.subscriptionplan.pay}    ${SHORT_WAIT}    Pay button is not visible after waiting ${SHORT_WAIT}seconds
    Run Keyword If    '${element}'=='Pay Button'    SeleniumLibrary.Click Element    ${button.login.profilepage.subscriptionplan.pay}
    Run Keyword If    '${element}'=='Pay Button'    Set Test Message    Payment Details is Displayed
    Run Keyword If    '${element}'=='UPI QR Scaner'    Wait Until Element Is Visible    ${icon.login.profilepage.subscriptionplan.clickpaybutton.upiqrscaner}    ${SHORT_WAIT}    UPI QR Scaner is not visible after waiting ${SHORT_WAIT}seconds
    Run Keyword If    '${element}'=='No History for New User'    Wait Until Element Is Visible    ${label.login.profilepage.purchageshistory.nohistory}    ${SHORT_WAIT}    No History label is not visible after waiting ${SHORT_WAIT} seconds
    Run Keyword If    '${element}'=='Navigate Back Before Submit'    Element Should Not Be Visible    ${label.login.test.start.timer}
    Run Keyword If    '${element}'=='Navigate Back After Submit'    Element Should Not Be Visible    ${label.login.test.start.timer}
    Run Keyword If    '${element}'=='Navigate Back After Submit'    Set Test Message    User is not able to navigate back to test after completion

Validate Topics and Available Levels
    [Arguments]    ${topic_name}=None    ${selected_levelname}=None    ${select_questions}=None    ${value}=None
    [Documentation]    Description: Validate Topics and available levels.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 07-Aug-2023
    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectiontopics}
    Wait Until Time    2
    ${total_qns_available}    Get Text    (//a[text()="${topic_name}"]/following::td[@valign="middle"])[1]
    Wait Until Element Is Visible    (//a[text()="${topic_name}"])[1]    ${MEDIUM_WAIT}    Topic name is not visible after waiting ${MEDIUM_WAIT} seconds
    SeleniumLibrary.Click Element    (//a[text()="${topic_name}"])[1]
    SeleniumLibrary.Unselect Frame
    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectionlevels}
    Wait Until Element Is Visible    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel1}    ${MEDIUM_WAIT}    Levels available qns is not visible after waiting ${MEDIUM_WAIT} seconds
    Wait Until Time    2
    ${level1_totalqns}    Get Value    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel1}
    ${level1_lower}    Evaluate    ${level1_totalqns}-1
    ${level1_decre}    Set Variable    ${level1_lower}
    ${level2_totalqns}    Get Value    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel2}
    ${level2_lower}    Evaluate    ${level2_totalqns}-1
    ${level2_decre}    Set Variable    ${level2_lower}
    ${level3_totalqns}    Get Value    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel3}
    ${level3_lower}    Evaluate    ${level3_totalqns}-1
    ${level3_decre}    Set Variable    ${level3_lower}
    ${total}    Set Variable    ${level1_totalqns},${level2_totalqns},${level3_totalqns}
    Should Be Equal    ${total}    ${total_qns_available}
    Set Test Message    Available Levels are autopopulated with number of questions for topic selected
    Run Keyword If    '${value}'=='Non Zero'    Should Not Be Equal    ${total_qns_available}    0,0,0
    Run Keyword If    '${value}'=='Non Zero'    Set Test Message    All Available level Questions not Equal to Zero
    Run Keyword If    '${value}'=='Update Topic'    Set Test Message    Levels are updated based on selecting a new topic.
    Run Keyword If    '${value}'=='Disabled Levels'    Element Should Be Disabled    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel1}
    Run Keyword If    '${value}'=='Disabled Levels'    Element Should Be Disabled    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel2}
    Run Keyword If    '${value}'=='Disabled Levels'    Element Should Be Disabled    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel3}
    Run Keyword If    '${value}'=='Disabled Levels'    Set Test Message    Available Levels are in Disabled
    Run Keyword If    '${select_questions}'!='None'    Wait Until Element Is Visible    //input[@name="${selected_levelname}"]    ${MEDIUM_WAIT}    Selecte Questions is not visible after waiting
    Run Keyword If    '${select_questions}'!='None'    SeleniumLibrary.Input Text    //input[@name="${selected_levelname}"]    ${select_questions}
    ${level1}    Run Keyword If    '${value}'=='Level 1 Over Limit'    Evaluate    ${level1_totalqns}+1
    ${level1_incre}    Run Keyword If    '${value}'=='Level 1 Over Limit'    Set Variable    ${level1}
    ${level2}    Run Keyword If    '${value}'=='Level 2 Over Limit'    Evaluate    ${level2_totalqns}+1
    ${level2_incre}    Run Keyword If    '${value}'=='Level 2 Over Limit'    Set Variable    ${level2}
    ${level3}    Run Keyword If    '${value}'=='Level 3 Over Limit'    Evaluate    ${level3_totalqns}+1
    ${level3_incre}    Run Keyword If    '${value}'=='Level 3 Over Limit'    Set Variable    ${level3}
    Run Keyword If    '${value}'=='Level 1 Over Limit'    SeleniumLibrary.Input Text    //input[@name="${selected_levelname}"]    ${level1_incre}
    Run Keyword If    '${value}'=='Level 2 Over Limit'    SeleniumLibrary.Input Text    //input[@name="${selected_levelname}"]    ${level2_incre}
    Run Keyword If    '${value}'=='Level 3 Over Limit'    SeleniumLibrary.Input Text    //input[@name="${selected_levelname}"]    ${level3_incre}
    Run Keyword If    '${value}'=='Level 1 Lesser value'    SeleniumLibrary.Input Text    //input[@name="${selected_levelname}"]    ${level1_decre}
    Run Keyword If    '${value}'=='Level 2 Lesser value'    SeleniumLibrary.Input Text    //input[@name="${selected_levelname}"]    ${level2_decre}
    Run Keyword If    '${value}'=='Level 3 Lesser value'    SeleniumLibrary.Input Text    //input[@name="${selected_levelname}"]    ${level3_decre}
    SeleniumLibrary.Unselect Frame

View and Validate Profile Screen Active Details
    [Documentation]    Description: View and Validate Profile Screen Active Details
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 07-Aug-2023
    Wait Until Element Is Visible    ${label.login.profilepage.profileheading}
    Wait Until Element Is Visible    ${Label.login.profilepage.activeplandetails}    ${SHORT_WAIT}    Active Details is not Visible after waiting for ${SHORT_WAIT} seconds
    ${header_details}    Get Text    ${Label.login.profilepage.activeplandetails}
    Set Test Message    Profile Header and Active plan details is displayed

Validate Whatsapp Number and Payment Details for Subscription Plan
    [Documentation]    Description: Validate Whatsapp Number and Payment Details for Subscription Plan.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 07-Aug-2023
    Wait Until Element Is Visible    ${label.login.profilepage.subscription.clickpaybutton.whatsappdetails}    ${SHORT_WAIT}    payment details with whatsapp number is not visible after waiting ${SHORT_WAIT} seconds
    ${payment_details}    Get Text    ${label.login.profilepage.subscription.clickpaybutton.whatsappdetails}
    Set Test Message    payment details with whatsapp number is displayed

Validate Subscription Plan Error Message
    [Documentation]    Description: Validate Subscription plan Error Message
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 10-Aug-2023
    Wait Until Element Is Visible    ${label.login.profilepage.subscriptionplan.monthlyplan}    ${MEDIUM_WAIT}    Monthly plan is visible after waiting ${MEDIUM_WAIT} seconds
    Mouse Over    ${label.login.profilepage.subscriptionplan.monthlyplan}
    Validate Elements in Create Template    ${test_data}[Element1]
    Wait Until Time    1
    ${selected_msg}    Get Element Attribute    ${label.login.profilepage.subscriptionplan.monthlyplan}    validationMessage
    Should Be Equal    ${selected_msg}    Please select one of these options.

Click on Forgot Password Hyperlink
    [Documentation]    Description: Click on Forgot password hyperlink
    ...
    ...    Author Name: Sangavi gampa
    ...
    ...    Designed Date: 18-08-2023
    Maximize Browser Window
    SeleniumLibrary.Wait Until Element Is Visible    ${button.url.forgot_password}    ${LONG_WAIT}    Forgot Password is not visible after waiting ${LONG_WAIT} seconds
    SeleniumLibrary.Click Element    ${button.url.forgot_password}
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.url.forgot_password_email}    ${LONG_WAIT}    email Password is not visible after waiting ${LONG_WAIT} seconds
    SeleniumLibrary.Wait Until Element Is Visible    ${button.url.forgot_password.email.submit}    ${LONG_WAIT}    submit Password is not visible after waiting ${LONG_WAIT} seconds
    log    Email field and submit button are displayed

Validate Error Message in Forgot Password
    [Arguments]    ${element}    ${email}=None
    [Documentation]    Description: Validate Erropr message in Forgot password
    ...
    ...    Author Name: Sangavi gampa
    ...
    ...    Designed Date: 18-08-2023
    SeleniumLibrary.Wait Until Element Is Visible    ${button.url.forgot_password.email.input}    ${LONG_WAIT}    email Password is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='invaild mail'    SeleniumLibrary.Input Text    ${text.url.forgot_password.email}    ${email}
    Run Keyword If    '${element}'=='No user mail'    SeleniumLibrary.Input Text    ${text.url.forgot_password.email}    ${email}
    SeleniumLibrary.Click Element    ${button.url.forgot_password.email.submit}
    Run Keyword If    '${element}'=='empty email'    SeleniumLibrary.Wait Until Element Is Visible    ${button.url.forgot_password.submit}    ${LONG_WAIT}    Please Enter Your email id is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='empty email'    LOG    "Please Enter Your email id"error message is displayed
    Run Keyword If    '${element}'=='invaild mail'    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.url.forgot_password.invaild.email.submit}    ${LONG_WAIT}    Enter valid Email Id is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='invaild mail'    LOG    "Enter valid Email Id" error message is displayed
    Run Keyword If    '${element}'=='No user mail'    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.url.fp.input}    ${LONG_WAIT}    No users found.is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='No user mail'    LOG    "No users found." error message is displayed

Validate Report Module
    [Arguments]    ${element}
    [Documentation]    Description: Validate Report Module
    ...
    ...    Author Name: Sangavi gampa
    ...
    ...    Designed Date: 18-08-2023
    Run Keyword If    '${element}'=='reports'    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.profile.report}    ${LONG_WAIT}    Reports is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='reports screen'    SeleniumLibrary.Wait Until Element Is Visible    ${labels.login.profile.report.menu}    ${LONG_WAIT}    Reports Screen is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='reports screen'    LOG    Reports Screen with Message "No tests have been taken till now. Please take a test." is Displayed
    Run Keyword If    '${element}'=='report list'    SeleniumLibrary.Wait Until Element Is Visible    ${labels.login.reportslist}    ${LONG_WAIT}    Reports list is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='custom'    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.reports.text}    ${LONG_WAIT}    Custom is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='custom'    LOG    "Custom" is Displayed
    Run Keyword If    '${element}'=='Questions'    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.reports.text}    ${LONG_WAIT}    Questions is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='Questions'    LOG    "Questions" is Displayed
    Run Keyword If    '${element}'=='Timer'    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.reports.viewtimer}    ${LONG_WAIT}    Timer is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='Timer'    LOG    "Timer" is Displayed
    Run Keyword If    '${element}'=='Marks'    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.reports.text}    ${LONG_WAIT}    Marks is not visible after waiting ${LONG_WAIT} seconds
    Run Keyword If    '${element}'=='Marks'    LOG    "Marks" is Displayed

Click and Validate Add and Save Button in Add Template Page
    [Arguments]    ${element1}=None    ${template_name}=None    ${element2}=None    ${value}=None
    [Documentation]    Description: Click and Validate Add and Save Button in Add Template Page
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 24-Aug-2023
    Wait Until Time    2
    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectionlevels}
    Run Keyword If    '${element1}'=='Add Template Add Button'    Wait Until Element Is Visible    ${link.login.profilepage.createtemplate.addtemplatelist.add}    ${MEDIUM_WAIT}    Add button is not visible after waiting for ${MEDIUM_WAIT} seconds
    Run Keyword If    '${element1}'=='Add Template Add Button'    SeleniumLibrary.Click Element    ${link.login.profilepage.createtemplate.addtemplatelist.add}
    Run Keyword And Ignore Error    Validate Handle Alert Confirmation for Account Settings Page
    Run Keyword If    '${template_name}'!='None'    Wait Until Element Is Visible    ${textbox.url.ctemp.add.templatename}    ${MEDIUM_WAIT}    Template Name is not visible after waiting ${MEDIUM_WAIT} seconds
    Run Keyword If    '${template_name}'!='None'    SeleniumLibrary.Input Text    ${textbox.url.ctemp.add.templatename}    ${template_name}
    Mouse Over    ${textbox.url.ctemp.add.templatename}
    Run Keyword If    '${element2}'=='Add Template Save Button'    Wait Until Element Is Visible    ${button.login.profilepage.createtemplate.addtemplatelist.save}    ${MEDIUM_WAIT}    Save button is not visible after waiting for ${MEDIUM_WAIT} seconds
    Run Keyword If    '${element2}'=='Add Template Save Button'    SeleniumLibrary.Click Element    ${button.login.profilepage.createtemplate.addtemplatelist.save}
    Wait Until Time    1
    ${selected_msg}    Run Keyword If    '${value}'=='Empty Template Name'    Get Element Attribute    ${textbox.url.ctemp.add.templatename}    validationMessage
    Run Keyword If    '${value}'=='Empty Template Name'    Should Be Equal    ${selected_msg}    Please fill in this field.
    SeleniumLibrary.Unselect Frame

Validate Selected Quentions in Add Templated
    [Arguments]    ${topic_name}=None    ${value}=None
    [Documentation]    Description: Validate Topics and available levels.
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 07-Aug-2023
    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectiontopics}
    Wait Until Time    2
    ${total_qns_available}    Get Text    (//a[text()="${topic_name}"]/following::td[@valign="middle"])[1]
    Wait Until Element Is Visible    (//a[text()="${topic_name}"])[1]    ${MEDIUM_WAIT}    Topic name is not visible after waiting ${MEDIUM_WAIT} seconds
    SeleniumLibrary.Click Element    (//a[text()="${topic_name}"])[1]
    SeleniumLibrary.Unselect Frame
    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectionlevels}
    Wait Until Element Is Visible    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel1}    ${MEDIUM_WAIT}    Levels available qns is not visible after waiting ${MEDIUM_WAIT} seconds
    Wait Until Time    2
    ${level1_totalqns}    Get Value    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel1}
    ${level1_lower}    Run Keyword If    ${level1_totalqns}>0    Evaluate    ${level1_totalqns}-1
    ...    ELSE    Set Variable    0
    ${level1_decre}    Set Variable    ${level1_lower}
    ${level2_totalqns}    Get Value    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel2}
    ${level2_lower}    Run Keyword If    ${level2_totalqns}>0    Evaluate    ${level2_totalqns}-1
    ...    ELSE    Set Variable    0
    ${level2_decre}    Set Variable    ${level2_lower}
    ${level3_totalqns}    Get Value    ${input.login.profilepage.createtemplate.addtemplate.availablequestionslevel3}
    ${level3_lower}    Run Keyword If    ${level3_totalqns}>0    Evaluate    ${level3_totalqns}-1
    ...    ELSE    Set Variable    0
    ${level3_decre}    Set Variable    ${level3_lower}
    Run Keyword If    ${level1_totalqns}>0    SeleniumLibrary.Input Text    ${textbox.url.ctemp.add.selectqns}    ${level1_decre}
    Run Keyword If    ${level2_totalqns}>0    SeleniumLibrary.Input Text    ${label.login.profilepage.createtemplate.selectaddbutton.addtemplate.selectedlevel2}    ${level2_decre}
    Run Keyword If    ${level3_totalqns}>0    SeleniumLibrary.Input Text    ${label.login.profilepage.createtemplate.selectaddbutton.addtemplate.selectedlevel3}    ${level3_decre}
    SeleniumLibrary.Unselect Frame
    Run Keyword If    '${value}'=='Total Quetions Count'    Click and Validate Add and Save Button in Add Template Page    Add Template Add Button
    ${total_selected_qns}    Run Keyword If    '${value}'=='Total Quetions Count'    Evaluate    ${level1_decre}+${level2_decre}+${level3_decre}
    Run Keyword If    '${value}'=='Total Quetions Count'    SeleniumLibrary.Select Frame    ${link.login.profilepage.createtemplate.addtemplatelist.iframesectionlevels}
    Run Keyword If    '${value}'=='Total Quetions Count'    Wait Until Element Is Visible    ${login.profilepage.createtemplate.addtemplate.totalnumberofquetions}    ${LONG_WAIT}    Total Questions is not visible after waiting for ${LONG_WAIT} seconds
    Run Keyword If    '${value}'=='Total Quetions Count'    Wait Until Time    2
    ${total_qns_value}    Run Keyword If    '${value}'=='Total Quetions Count'    Get Value    ${login.profilepage.createtemplate.addtemplate.totalnumberofquetions}
    ${total_qns_value}    Run Keyword If    '${value}'=='Total Quetions Count'    Convert To Integer    ${total_qns_value}
    Run Keyword If    '${value}'=='Total Quetions Count'    Set Test Message    updated Total Questions as ${total_qns_value}
    Run Keyword If    '${value}'=='Total Quetions Count'    Should Be Equal    ${total_qns_value}    ${total_selected_qns}
    Run Keyword If    '${value}'=='Total Quetions Count'    Set Test Message    Total Questions are Equal to the Selected Questions
    SeleniumLibrary.Unselect Frame

Switch to Window
    [Documentation]    Description: Validate Switch to Window
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 24-Aug-2023
    Wait Until Time    4
    Switch Window    New

Validate Check Boxes in Template List
    [Arguments]    ${element}    ${position}    ${numofcheckboxes}
    [Documentation]    Description: Validate Check Boxes for INQ
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 29-Aug-2023
    Wait Until Time    4
    ${checkboxes_count}    Get Element Count    ${checkbox.login.profilepage.createtemplate.totalcheckboxescount}
    Set Test Variable    ${checkboxes_count}
    ${selected_count}    Evaluate    ${numofcheckboxes}-1
    Set Test Variable    ${selected_count}
    FOR    ${key}    IN RANGE    ${position}    ${numofcheckboxes}
        Run Keyword If    '${element}'=='Multiple check boxes'    Wait Until Element Is Visible    ${checkbox.login.profilepage.createtemplate.firstcheckbox}    ${LONG_WAIT}    Checkbox is not visible after waiting for ${LONG_WAIT} seconds
        Run Keyword If    '${element}'=='Multiple check boxes'    Click Element    (//tbody//tr//td//input[@type="checkbox"])[${key}]
    END

Validate Active Plans in Profile Screen
    [Documentation]    Description: Validate Active Plans in Profile Screen
    ...
    ...    Author Name : Kancherla Ramya
    ...
    ...    Date: 29-Aug-2023
    Wait Until Time    2
    ${tests}    Get Text    ${label.login.profilepage.testsallotted}
    ${removed1}    Remove String    ${tests}    ,    :    ${SPACE}
    ${testsalloted}    Remove String    ${removed1}    Testsallotted
    Set Test Message    Tests Allotted :${testsalloted}
    ${remaining_tests}    Get Text    ${label.login.profilepage.remainingtests}
    ${removed2}    Remove String    ${remaining_tests}    ,    :    ${SPACE}
    ${remainingtests_available}    Remove String    ${removed2}    RemainingTests
    Set Test Message    Remaining Tests :${testsalloted}
    ${validity_expire_date}    Get Text    ${label.login.profilepage.validityexpiredate}
    ${removed3}    Remove String    ${validity_expire_date}    ,    :    ${SPACE}
    ${expire_date}    Remove String    ${removed3}    validityexpiredate
    Set Test Message    Validity Expire Date :${testsalloted}

Click and Validate View Test Report Screen
    [Arguments]    ${name1}=None    ${name2}=None    ${sub}=None    ${marks}=None    ${results}=None    ${ans}=None
    ${name1}    Run Keyword If    '${name1}'=="Name1"    Get Text    ${label.test.viewreport.name}
    Run Keyword If    '${name1}'=="Name1"    Set Global Variable    ${name1}
    ${name2}    Run Keyword If    '${name2}'=="Name2"    Get Text    ${label.test.viewreport.name}
    Run Keyword If    '${name2}'=="Name2"    log    ${name2}
    Run Keyword If    '${name2}'=="Name2"    Should Be Equal    ${name1}    ${name2}
    Run Keyword If    '${sub}'=="Subject"    Click Element    ${button.url.test.viewr.resultdetailed}
    Run Keyword If    '${sub}'=="Subject"    Wait Until Element Is Visible    ${label.login.test.vr.rd.sub}    ${LONG_WAIT}    Subject is not visible after waiting ${LONG_WAIT}
    ${subject}    Run Keyword If    '${sub}'=="Subject"    Get Text    ${label.login.test.vr.rd.sub}
    Run Keyword If    '${sub}'=="Subject"    Log    Subject ${subject} is Displayed
    Run Keyword If    '${marks}'=="Awarded Marks"    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.viewreport.marks}    ${SHORT_WAIT}    Awarded marks are not visible waiting ${SHORT_WAIT}
    Run Keyword If    '${marks}'=="Awarded Marks"    Set Test Message    Awarded Marks are visible after submitting test
    Run Keyword If    '${results}'=="Results Details"    Click Element    ${button.login.test.submit.result}
    Run Keyword If    '${results}'=="Results Details"    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.viewrp.resulttable}    ${SHORT_WAIT}    Result table is not visible waiting ${SHORT_WAIT}
    Run Keyword If    '${results}'=="Results Details"    Set Test Message    Result Table is visible after clicking result tab in view report screen
    Run Keyword If    '${ans}'=="Answer Sheet"    Click Element    ${buttons.login.test.vrt.ans}
    Run Keyword If    '${ans}'=="Answer Sheet"    SeleniumLibrary.Wait Until Element Is Visible    ${label.login.test.vreport.anssheet}    ${SHORT_WAIT}    Answer sheet is not visible waiting ${SHORT_WAIT}
    Run Keyword If    '${results}'=="Results Details"    Set Test Message    Answer sheet is visible after clicking answer tab in view report screen
    [Return]    ${name1}

Validate Allotted Test Message
    [Arguments]    ${message}
    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.test}    ${MEDIUM_WAIT}    Test is not visible after waiting ${MEDIUM_WAIT}
    SeleniumLibrary.Click Element    ${label.url.test}
    SeleniumLibrary.Click Element    ${icon.url.test.tempname.greatericon}
    Validate Success or Error Message    ${message}

Click and Add Template Details in Create Template Screen
    [Arguments]    ${qns}    ${template}    ${sub}
    [Documentation]    Description: click on template screen and add template details
    ...
    ...    Author Name: Hemalatha
    ...
    ...    Designed Date: 07-08-2023
    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.createtemplate}    ${LONG_WAIT}    Create Template is not visible after waiting ${LONG_WAIT} seconds
    SeleniumLibrary.Click Element    ${label.url.createtemplate}
    SeleniumLibrary.Wait Until Element Is Visible    ${button.utl.createtemplate.add}    ${LONG_WAIT}    Add is not visible after waiting ${LONG_WAIT} seconds
    SeleniumLibrary.Click Element    ${button.utl.createtemplate.add}
    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.createtemplate.add.subject}    ${MEDIUM_WAIT}    Subject Frame is not visible after waiting ${MEDIUM_WAIT}
    Select Frame    ${label.url.createtemplate.add.subject}
    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    //select[@id="subjects"]/option[@id="subject_name"and text()[normalize-space()="${sub}"]]
    Unselect Frame
    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.ctemp.subject.topic}    ${MEDIUM_WAIT}    Topics Frame is not visible after waiting ${MEDIUM_WAIT}
    Select Frame    ${label.url.ctemp.subject.topic}
    Wait Until Keyword Succeeds    10s    2s    Click Element    ${label.url.ctemp.add.topicname}
    Unselect Frame
    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.ctemp.topic.availableqns}    ${MEDIUM_WAIT}    Available Questions Frame is not visible after waiting ${MEDIUM_WAIT}
    Select Frame    ${label.url.ctemp.topic.availableqns}
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.url.ctemp.add.selectqns}    ${MEDIUM_WAIT}    Selected questions is not visible after waiting ${MEDIUM_WAIT}
    Press Keys    ${textbox.url.ctemp.add.selectqns}    CTRL+a+BACKSPACE
    SeleniumLibrary.Input Text    ${textbox.url.ctemp.add.selectqns}    ${qns}
    Click Element    ${button.ctemp.add.qns.add}
    Handle Alert    ACCEPT
    Wait Until Time    2
    Handle Alert    ACCEPT
    Wait Until Time    2
    SeleniumLibrary.Input Text    ${textbox.url.ctemp.add.templatename}    ${template}
    Click Element    ${button.login.profilepage.accountsettingspage.submit}

Validate and Add Template
    [Arguments]    ${qns}    ${template}    ${sub}
    SeleniumLibrary.Wait Until Element Is Visible    ${label.url.createtemplate}    ${LONG_WAIT}    Create Template is not visible after waiting ${LONG_WAIT} seconds
    SeleniumLibrary.Click Element    ${label.url.createtemplate}
    ${status}    Run Keyword And Return Status    SeleniumLibrary.Wait Until Element Is Visible    //form[@name="form1"]/table//tbody//tr[1]/td[3]/p    ${SHORT_WAIT}    Template name is not visible after waiting ${SHORT_WAIT} seconds
    Run Keyword If    ${status}==False    Click and Add Template Details in Create Template Screen    ${qns}    ${template}    ${sub}

sample
    [Arguments]    ${element}
    Run Keyword If    '${element}'=='Navigate Back Before Submit'    Go Back
    Run Keyword If    '${element}'=='Navigate Back After Submit'    Go Back
    Run Keyword If    '${element}'=='Navigate Back After Submit'    Handle Alert    ACCEPT
    Wait Until Time    2
    Run Keyword If    '${element}'=='Navigate Back Before Submit'    Element Should Not Be Visible    ${label.login.test.start.timer}
    Run Keyword If    '${element}'=='Navigate Back After Submit'    Element Should Not Be Visible    ${label.login.test.start.timer}
    Run Keyword If    '${element}'=='Navigate Back After Submit'    Set Test Message    User is not able to navigate back to test after completion
Enter New Password and Login with New Password
    [Arguments]    ${current_password}    ${new_password}    ${confirm_password}
    Comment    Comment    Enter Current Password
    Comment    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    ${textbox.changepassword.current password}
    Comment    SeleniumLibrary.Input Text    ${textbox.changepassword.current password}    ${PASSWORD FOR CHANGE PASSWORD}
    Comment    Comment    Enter New Password
    Comment    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    ${textbox.changepassword.new password}
    Comment    SeleniumLibrary.Input Text    ${textbox.changepassword.new password}    ${New Password}
    Comment    Set Global Variable    ${New Password}
    Comment    Comment    Enter Confirm Password
    Comment    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    ${textbox.changepassword.confirm password}
    Comment    SeleniumLibrary.Input Text    ${textbox.changepassword.confirm password}    ${Confirm Password}
    Comment    SeleniumLibrary.Click Element    ${button.login.profilepage.accountsettingspage.submit}
    Comment    Validate Success or Error Message    ${test_data}[SuccessMessage]
    Comment    Comment    Click on Logout Button
    Comment    Wait Until Time    5
    Comment    SeleniumLibrary.Click Element    //*[@id="menu"]/div/ul/li[6]/a
    Comment    Comment    Validate Logout Button for Profile Page    ${test_data}[Value2]
    Comment    Comment    Login with New Password
    Comment    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    ${textbox.login.emailid}
    Comment    SeleniumLibrary.Input Text    ${textbox.login.emailid}    ${USERNAME FOR CHANGE PASSWORD}
    Comment    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    ${textbox.login.password}
    Comment    SeleniumLibrary.Input Text    ${textbox.login.password}    ${New Password}
    Comment    SeleniumLibrary.Click Element    ${button.loginpage.loginbutton}
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.changepassword.current password}    ${LONG_WAIT}    Current Password is not Visible after waiting for ${LONG_WAIT} seconds
    SeleniumLibrary.Input Text    ${textbox.changepassword.current password}    ${current_password}
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.changepassword.new password}    ${LONG_WAIT}    New Password is not Visible after waiting for ${LONG_WAIT} seconds
    SeleniumLibrary.Input Text    ${textbox.changepassword.new password}    ${new_password}
    ${new_password1}    Set Variable    ${new_password}
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.changepassword.confirm password}    ${LONG_WAIT}    Confirm Password is not Visible after waiting for ${LONG_WAIT} seconds
    SeleniumLibrary.Input Text    ${textbox.changepassword.confirm password}    ${confirm_password}
    ${confirm_password1}    Set Variable    ${confirm_password}
    SeleniumLibrary.Click Element    ${button.login.profilepage.accountsettingspage.submit}

Login to Application without Launch Browser
    [Arguments]    ${user_name}    ${password}
    Wait Until Element Is Visible    ${textbox.login.emailid}    ${LONG_WAIT}    Login page is not opened
    Input Text    ${textbox.login.emailid}    ${user_name}
    Input Text    ${textbox.login.password}    ${password}
    Click Button    ${button.loginpage.loginbutton}
    Set Test Message    Successfully log in to the Profile page.
    Wait Until Element Is Visible    ${label.login.profilepageheading}    ${SHORT_WAIT}    Login failed.Skillmill page is not displayed

Validate Check Box Count
    Wait Until Time    2
    ${checkboxes_aftercount}    Get Element Count    ${checkbox.login.profilepage.createtemplate.totalcheckboxescount}
    ${remaining_count}    Evaluate    ${checkboxes_count}-${selected_count}
    Should Be Equal    ${remaining_count}    ${checkboxes_aftercount}
