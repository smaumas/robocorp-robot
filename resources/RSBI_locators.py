""" Robot Order Page"""
elem_label_popup_rights = f'//*[@class="modal-body"]//p[text()="By using this order form, I give up all my constitutional rights for the benefit of RobotSpareBin Industries Inc."]'
elem_btn_popup_rights_ok = f'//*[@class="modal-body"]//div[@class="alert-buttons"]//button[text()="OK"]'
elem_dropdown_head = f'//select[@id="head"][@name="head"]'

elem_radio_body = f'//div[@class="radio form-check"]//*[contains(@id, "id-body")]'
elem_radio_stack = f'//*[@class="form-group" and label /text()="2. Body:"]//div[@class="stacked"]'
elem_radio_value = '//div[@class="radio form-check"]//*[@type="radio" and @value={value}]'

elem_txtbox_legs = f'//*[@class="form-group" and label /text()="3. Legs:"]//*[@class="form-control"]'

elem_txtbox_address = f'//*[@class="form-control"][@id="address"]'
elem_btn_preview = f'//button[@id="preview"]'
elem_btn_order = f'//button[@id="order"]'

elem_label_warning = f'//div[@class="alert alert-danger"][@role="alert"]'

elem_label_receipt = f'//div[@id="order-completion"]//div[@id="receipt" and @class="alert alert-success"]'
elem_img_robot = f'//div[@id="robot-preview"]//div[@id="robot-preview-image"]'

elem_btn_orderAnother = f'//button[@id="order-another"]'
