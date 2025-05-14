import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Widget buildTextFieldWithController(TextEditingController controller,
    TextInputType inputType, bool isReadOnly) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: inputType,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF7A0000)),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF7A0000)),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF7A0000)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}

Widget buildTextFieldF(TextEditingController controller, bool isReadOnly,
    TextInputType inputType) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          keyboardType: inputType,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF7A0000)),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF7A0000)),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF7A0000)),
              borderRadius: BorderRadius.circular(16),
            ),
            fillColor: const Color.fromARGB(255, 201, 201, 201),
            filled: true,
          ),
        ),
      ],
    ),
  );
}

Widget buildGovernorateDropdown(String? selectedGovernorate,
    List<String> governorates, Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'المحافظة',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Container(
          height: 57.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF7A0000)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            value: selectedGovernorate,
            hint: const Text(
              'اختر المحافظة',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey),
            ),
            items: governorates.map((String governorate) {
              return DropdownMenuItem<String>(
                value: governorate,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    governorate,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF7A0000),
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            dropdownColor: const Color.fromARGB(255, 225, 223, 223),
            alignment: AlignmentDirectional.centerEnd,
          ),
        ),
      ],
    ),
  );
}

Widget buildConstituencyDropdown(String? selectedConstituency,
    List<String> constituencies, Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'الدائرة الانتخابية للقائمة',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Container(
          height: 57.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF7A0000)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            value: selectedConstituency,
            hint: const Text(
              'اختر الدائرة الانتخابية',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey),
            ),
            items: constituencies.map((String constituency) {
              return DropdownMenuItem<String>(
                value: constituency,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    constituency,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF7A0000),
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            dropdownColor: const Color.fromARGB(255, 225, 223, 223),
            alignment: AlignmentDirectional.centerEnd,
          ),
        ),
      ],
    ),
  );
}

Widget buildFileUploadField(
    String label,
    Map<String, PlatformFile?> uploadedFiles,
    Function(String, PlatformFile) handleFileUpload) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null && result.files.isNotEmpty) {
              handleFileUpload(label, result.files.first);
            }
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7A0000)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                uploadedFiles.containsKey(label) && uploadedFiles[label] != null
                    ? uploadedFiles[label]!.name
                    : 'اضغط لرفع الملف',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
