import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../components/colors.dart';
import '../../components/my_text_field.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  String? _selectedCategory;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Upload Image: "),
              Row(
                children: [
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text(
                      "Pick image",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.file(
                        _selectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Product name: "),
              MyTextField(
                controller: _productName,
                hintText: "Name",
                obscureText: false,
              ),
              const SizedBox(height: 16),
              const Text("Product description: "),
              MyTextField(
                controller: _description,
                hintText: "Description",
                obscureText: false,
              ),
              const SizedBox(height: 16),
              const Text("Product category: "),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text("Select a category"),
                items: const [
                  DropdownMenuItem(value: "Salad", child: Text("Salad")),
                  DropdownMenuItem(value: "Rolls", child: Text("Rolls")),
                  DropdownMenuItem(value: "Deserts", child: Text("Deserts")),
                  DropdownMenuItem(value: "Sandwich", child: Text("Sandwich")),
                  DropdownMenuItem(value: "Cake", child: Text("Cake")),
                  DropdownMenuItem(value: "Pure Veg", child: Text("Pure Veg")),
                  DropdownMenuItem(value: "Pasta", child: Text("Pasta")),
                  DropdownMenuItem(value: "Noodles", child: Text("Noodles")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text("Product Price: "),
              MyTextField(
                controller: _price,
                hintText: "Price",
                obscureText: false,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 50)),
                        backgroundColor: WidgetStateProperty.all(tomoto),
                        shape: WidgetStateProperty.all(BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(3)))),
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
