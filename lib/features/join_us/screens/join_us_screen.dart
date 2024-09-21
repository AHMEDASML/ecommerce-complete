import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/join_us/controllers/join_us_controllers.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utill/app_constants.dart';

class JoinUsScreen extends StatefulWidget {
  const JoinUsScreen({super.key});

  @override
  State<JoinUsScreen> createState() => _JoinUsScreenState();
}

class _JoinUsScreenState extends State<JoinUsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  bool isLoading = false; // حالة التحميل

  final JoinUsController _joinUsController = Get.put(JoinUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('join_us', context)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text(
                  getTranslated(
                      'To know the details of how to become a partner of the Win by Win store, register your information and the relevant department will contact you as soon as possible.',
                      context)!,
                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault),
                child: CustomTextFieldWidget(
                    hintText: getTranslated('first_name', context),
                    labelText: getTranslated('first_name', context),
                    inputType: TextInputType.name,
                    required: true,
                    focusNode: _fNameFocus,
                    nextFocus: _lNameFocus,
                    prefixIcon: Images.username,
                    capitalization: TextCapitalization.words,
                    controller: _firstNameController,
                    validator: (value) => ValidateCheck.validateEmptyText(
                        value, "first_name_field_is_required"))),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault,
                    top: Dimensions.marginSizeSmall),
                child: CustomTextFieldWidget(
                    hintText: getTranslated('enter_your_email', context),
                    labelText: getTranslated('enter_your_email', context),
                    focusNode: _emailFocus,
                    nextFocus: _phoneFocus,
                    required: true,
                    inputType: TextInputType.emailAddress,
                    controller: _emailController,
                    prefixIcon: Images.email,
                    validator: (value) => ValidateCheck.validateEmail(value))),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault,
                    top: Dimensions.marginSizeSmall),
                child: CustomTextFieldWidget(
                    hintText: getTranslated('enter_mobile_number', context),
                    labelText: getTranslated('enter_mobile_number', context),
                    controller: _phoneController,
                    focusNode: _phoneFocus,
        
                    // nextFocus: _passwordFocus,
                    required: true,
                    prefixIcon: Images.city,
                    // showCodePicker: true,
                    // countryDialCode: authProvider.countryDialCode,
                    // onCountryChanged: (CountryCode countryCode) {
                    //   _phoneFocus.requestFocus();
                    //   authProvider.countryDialCode = countryCode.dialCode!;
                    //   authProvider.setCountryCode(countryCode.dialCode!);
                    // },
                    isAmount: true,
                    validator: (value) => ValidateCheck.validateEmptyText(
                        value, "phone_must_be_required"),
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.phone)),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : InkWell(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
        
                      String firstName = _firstNameController.text;
                      String email = _emailController.text;
                      String phone = _phoneController.text;
        
                      await _joinUsController.sendJoinRequest(context: context,
                        name: firstName,
                        phone: phone,
                        email: email,
                      );
        
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor),
                        child: Text(
                          getTranslated('send_a_request_to_join', context)!,
                          style: titilliumSemiBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Provider.of<ThemeController>(context,
                                          listen: false)
                                      .darkTheme
                                  ? Theme.of(context).hintColor
                                  : Theme.of(context).highlightColor),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
