class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return "Phone is required";
    if (value.trim().length < 10) return "Enter valid phone number";
    return null;
  }
}
