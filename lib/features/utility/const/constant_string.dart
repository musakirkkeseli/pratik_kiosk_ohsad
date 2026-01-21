import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/custom_extension.dart';

import 'environment.dart';
import 'locale_keys.g.dart';

class ConstantString {
  static var backendUrl = Environment.backendUrl;

  // Localization
  // ignore: constant_identifier_names
  static const SUPPORTED_LOCALE = [
    ConstantString.TR_LOCALE,
    ConstantString.EN_LOCALE,
    ConstantString.AR_LOCALE,
  ];
  static const TR_LOCALE = Locale("tr", "TR");
  static const EN_LOCALE = Locale('en', 'EN');
  static const AR_LOCALE = Locale('ar', 'AR');
  static const LANG_PATH = "assets/lang";
  static const turkish = "Türkçe";
  static const english = "English";
  static const arabic = "عربي";

  //urls
  static const form = "https://prtk.gen.tr/kiosk_forms.php";

  // Assets
  static const loadingGif = "assets/gif/loading.gif";
  static const posGif = "assets/gif/pos_gif.json";
  static const healthGif = "assets/gif/health_gif.json";
  static const configLoading = "assets/gif/config_loading.json";
  static const settingsGif = "assets/gif/settings_gif.json";
  static const hospitalLogo = "assets/images/pratikLogo.png";
  static const configSetting = "assets/gif/config_setting.json";
  static const paymentLoading = "assets/gif/payment_loading.json";
  static const downloadImage = "assets/images/downloadImage.png";
  static const appstoreLight = "assets/images/appstore_light.png";
  static const appstoreDark = "assets/images/appstore_dark.png";
  static const googlePlayLight = "assets/images/google_play_light.png";
  static const googlePlayDark = "assets/images/google_play_dark.png";

  // Localized Strings

  String isThisNumberYoursWithPhone(String phoneNumber) =>
      LocaleKeys.isThisNumberYoursWithPhone.localArg([phoneNumber]);

  String welcomeUser(String userName) =>
      LocaleKeys.welcomeUser.localArg([userName]);

  String birthDate = LocaleKeys.birthDate.locale;
  String signIn = LocaleKeys.signIn.locale;
  String patientLogin = LocaleKeys.patientLogin.locale;
  String hospitalLogin = LocaleKeys.hospitalLogin.locale;
  String appointments = LocaleKeys.appointments.locale;
  String logout = LocaleKeys.logout.locale;
  String homePageTitle = LocaleKeys.homePageTitle.locale;
  String selectBranch = LocaleKeys.selectBranch.locale;
  String branches = LocaleKeys.branches.locale;
  String selectDoctor = LocaleKeys.selectDoctor.locale;
  String errorOccurred = LocaleKeys.errorOccurred.locale;
  String noAppointments = LocaleKeys.noAppointments.locale;
  String internetConnectionError = LocaleKeys.internetConnectionError.locale;
  String checkInternetConnection = LocaleKeys.checkInternetConnection.locale;
  String associationGssInfoMessage =
      LocaleKeys.associationGssInfoMessage.locale;
  String fieldRequired = LocaleKeys.fieldRequired.locale;
  String minLengthError = LocaleKeys.minLengthError.locale;
  String priceInformation = LocaleKeys.priceInformation.locale;
  String sectionSelection = LocaleKeys.sectionSelection.locale;
  String section = LocaleKeys.section.locale;
  String doctorSelection = LocaleKeys.doctorSelection.locale;
  String doctor = LocaleKeys.doctor.locale;
  String patientTransaction = LocaleKeys.patientTransaction.locale;
  String mandatoryFields = LocaleKeys.mandatoryFields.locale;
  String payment = LocaleKeys.payment.locale;
  String makeSecurePayment = LocaleKeys.makeSecurePayment.locale;
  String total = LocaleKeys.total.locale;
  String insurance = LocaleKeys.insurance.locale;
  String enterYourTurkishIdNumber = LocaleKeys.enterYourTurkishIdNumber.locale;
  String clear = LocaleKeys.clear.locale;
  String patientRegistration = LocaleKeys.patientRegistration.locale;
  String testQueue = LocaleKeys.testQueue.locale;
  String results = LocaleKeys.results.locale;
  String appointmentRegistration = LocaleKeys.appointmentRegistration.locale;
  String registration = LocaleKeys.registration.locale;
  String tests = LocaleKeys.tests.locale;
  String completeRegistration = LocaleKeys.completeRegistration.locale;
  String patientInformation = LocaleKeys.patientInformation.locale;
  String summaryAndInvoice = LocaleKeys.summaryAndInvoice.locale;
  String totalAmount = LocaleKeys.totalAmount.locale;
  String creditCardPayment = LocaleKeys.creditCardPayment.locale;
  String securePaymentMessage = LocaleKeys.securePaymentMessage.locale;
  String description = LocaleKeys.description.locale;
  String amount = LocaleKeys.amount.locale;
  String paymentSuccess = LocaleKeys.paymentSuccess.locale;
  String paymentFailure = LocaleKeys.paymentFailure.locale;
  String paymentPending = LocaleKeys.paymentPending.locale;
  String paymentProcessing = LocaleKeys.paymentProcessing.locale;
  String hour = LocaleKeys.hour.locale;
  String policlinic = LocaleKeys.policlinic.locale;
  String close = LocaleKeys.close.locale;
  String select = LocaleKeys.select.locale;
  String timeExpired = LocaleKeys.timeExpired.locale;
  String settingsApplying = LocaleKeys.settingsApplying.locale;
  String paymentAmount = LocaleKeys.paymentAmount.locale;
  String registrationFailed = LocaleKeys.registrationFailed.locale;
  String continueLabel = LocaleKeys.continueLabel.locale;
  String validateTcText = LocaleKeys.validateTcText.locale;
  String validateOTPText = LocaleKeys.validateOTPText.locale;
  String pleaseEnterSmsCode = LocaleKeys.pleaseEnterSmsCode.locale;
  String isThisNumberYours = LocaleKeys.isThisNumberYours.locale;
  String no = LocaleKeys.no.locale;
  String pleaseProceedToPatientAdmission =
      LocaleKeys.pleaseProceedToPatientAdmission.locale;
  String warning = LocaleKeys.warning.locale;
  String phoneNumberNotFound = LocaleKeys.phoneNumberNotFound.locale;
  String updatePhoneAtAdmission = LocaleKeys.updatePhoneAtAdmission.locale;
  String yes = LocaleKeys.yes.locale;
  String enterYourBirthDate = LocaleKeys.enterYourBirthDate.locale;
  String pleaseEnterValidBirthDate =
      LocaleKeys.pleaseEnterValidBirthDate.locale;
  String clearData = LocaleKeys.clearData.locale;
  String backToTop = LocaleKeys.backToTop.locale;
  String downloadOurApp = LocaleKeys.downloadOurApp.locale;
  String sessionTimeout = LocaleKeys.sessionTimeout.locale;
  String sessionWillCloseIfInactive =
      LocaleKeys.sessionWillCloseIfInactive.locale;
  String examinationRegistrationCreated =
      LocaleKeys.examinationRegistrationCreated.locale;
  String requirePaymentForExaminationRegistration =
      LocaleKeys.requirePaymentForExaminationRegistration.locale;
  String paymentCompletedSuccessfully =
      LocaleKeys.paymentCompletedSuccessfully.locale;
  String paymentCompletedFailed = LocaleKeys.paymentCompletedFailed.locale;
  String selectDepartment = LocaleKeys.selectDepartment.locale;
  String examinationDetails = LocaleKeys.examinationDetails.locale;
  String username = LocaleKeys.username.locale;
  String password = LocaleKeys.password.locale;
  String turkishIdNumber = LocaleKeys.turkishIdNumber.locale;
  String smsCode = LocaleKeys.smsCode.locale;
  String elevenDigitTurkishIdInfo = LocaleKeys.elevenDigitTurkishIdInfo.locale;
  String filledFieldInfo = LocaleKeys.filledFieldInfo.locale;
  String welcome = LocaleKeys.welcome.locale;
  String vatIncluded = LocaleKeys.vatIncluded.locale;
  String otherBranches = LocaleKeys.otherBranches.locale;
  String scanQrToAccessForm = LocaleKeys.scanQrToAccessForm.locale;
  String scanQrToFillSurvey = LocaleKeys.scanQrToFillSurvey.locale;
  String survey = LocaleKeys.survey.locale;
  String usernameRequired = LocaleKeys.usernameRequired.locale;
  String enterAtLeast3Characters = LocaleKeys.enterAtLeast3Characters.locale;
  String passwordRequired = LocaleKeys.passwordRequired.locale;
  String passwordMinLength = LocaleKeys.passwordMinLength.locale;
  String turkishIdRequired = LocaleKeys.turkishIdRequired.locale;
  String mustBe11Digits = LocaleKeys.mustBe11Digits.locale;
  String invalidTurkishId = LocaleKeys.invalidTurkishId.locale;
  String birthDateRequired = LocaleKeys.birthDateRequired.locale;
  String enterValidDateFormat = LocaleKeys.enterValidDateFormat.locale;
  String save = LocaleKeys.save.locale;
  String pleaseSignFirst = LocaleKeys.pleaseSignFirst.locale;
  String pleaseProvideSignature = LocaleKeys.pleaseProvideSignature.locale;
  String search = LocaleKeys.search.locale;
  String start = LocaleKeys.start.locale;
  String takeAppointment = LocaleKeys.takeAppointment.locale;
  String registerPatientForAppointment =
      LocaleKeys.registerPatientForAppointment.locale;
  String viewTestResults = LocaleKeys.viewTestResults.locale;
  String selectToMakeChoice = LocaleKeys.selectToMakeChoice.locale;
  String appointmentExistsForSelectedSection =
      LocaleKeys.appointmentExistsForSelectedSection.locale;
  String appointmentDetails = LocaleKeys.appointmentDetails.locale;
  String continueWithAppointment = LocaleKeys.continueWithAppointment.locale;
  String cancelAndSelectAnotherSection =
      LocaleKeys.cancelAndSelectAnotherSection.locale;
  String amountPaid = LocaleKeys.amountPaid.locale;
  String creditCard = LocaleKeys.creditCard.locale;
  String paymentMethod = LocaleKeys.paymentMethod.locale;
  String transactionDate = LocaleKeys.transactionDate.locale;
  String transactionNumber = LocaleKeys.transactionNumber.locale;
  String date = LocaleKeys.date.locale;
  String sectionName = LocaleKeys.sectionName.locale;
  String doctorName = LocaleKeys.doctorName.locale;
  String time = LocaleKeys.time.locale;
  String confirmation = LocaleKeys.confirmation.locale;
  String confirm = LocaleKeys.confirm.locale;
  String cancel = LocaleKeys.cancel.locale;
  String areYouSureToBookAppointment =
      LocaleKeys.areYouSureToBookAppointment.locale;
  String noAvailableAppointmentsForDoctor =
      LocaleKeys.noAvailableAppointmentsForDoctor.locale;
  String success = LocaleKeys.success.locale;
  String ok = LocaleKeys.ok.locale;
  String appointmentBookedMessage =
      LocaleKeys.appointmentSuccessfullyBooked.locale;
  String error = LocaleKeys.error.locale;
  String patientNotFound = LocaleKeys.patientNotFound.locale;
  String profDrRecords = LocaleKeys.profDrRecords.locale;
  String paymentTemporarilyUnavailable =
      LocaleKeys.paymentTemporarilyUnavailable.locale;
  String paymentSystemConnectionError =
      LocaleKeys.paymentSystemConnectionError.locale;
  String pleaseContactReception = LocaleKeys.pleaseContactReception.locale;
  String technicalTeamWorking = LocaleKeys.technicalTeamWorking.locale;
  String thankYouForUnderstanding = LocaleKeys.thankYouForUnderstanding.locale;
  String goBack = LocaleKeys.goBack.locale;
  String insuranceTypeNotFound = LocaleKeys.insuranceTypeNotFound.locale;
  String unexpectedError = LocaleKeys.unexpectedError.locale;
  String appointmentEntry = LocaleKeys.appointmentEntry.locale;
  String patientRecord = LocaleKeys.patientRecord.locale;
  String newIdCardLogin = LocaleKeys.newIdCardLogin.locale;
  String newIdCardScanInstruction = LocaleKeys.newIdCardScanInstruction.locale;
  String invalidBarcode = LocaleKeys.invalidBarcode.locale;
}
