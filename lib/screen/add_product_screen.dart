import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkjo/model/categories.dart';
import 'package:linkjo/service/api_service.dart';
import 'package:linkjo/utils/helper.dart';
import 'package:linkjo/utils/log.dart';
import 'package:linkjo/widget/app_button.dart';
import 'package:linkjo/widget/app_textfield.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final _api = ApiService();
  final ImagePicker _imgPicker = ImagePicker();
  final List<Categories> categories = [];
  final List<Categories> subcategories = [];
  XFile? image;
  int? selectedCategory;

  void _pickImage() async {
    image = await _imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void _getCategories() async {
    final res = await _api.get('/categories');
    if (res.success) {
      res.data.forEach((e) => categories.add(Categories.fromJson(e)));
      setState(() {});
    }
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preview'),
        content: Image.file(File(image!.path)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage();
            },
            child: const Text('Change'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addProduct() async {
    Helper.showLoadingDialog(context);
    final Map<String, dynamic> data = {
      "category_id": selectedCategory,
      "name": nameCtrl.text,
      "price": priceCtrl.text,
      "stock": stockCtrl.text,
      "unit": unitCtrl.text,
      "image": image?.path,
      "description": descCtrl.text,
    };
    Log.d(data);
    List<String> imgKeys = ["image"];

    final res = await _api.postMultiFile("/products", data, imgKeys);
    Navigator.pop(context);
    if (res.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.message!),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField(
            items: categories
                .map(
                  (e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                subcategories.clear();
                selectedCategory = null;
                for (var e in categories) {
                  if (e.children == null || e.children!.isEmpty) continue;
                  for (var s in e.children!) {
                    if (s.parentId == value) {
                      subcategories.add(s);
                    }
                  }
                }
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField(
            items: subcategories
                .map(
                  (e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ),
                )
                .toList(),
            value: selectedCategory,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.category),
              labelText: 'Subcategory',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),
          const SizedBox(height: 16),
          AppTextfield(
            controller: nameCtrl,
            prefix: const Icon(Icons.food_bank),
            hintText: 'Product Name',
          ),
          const SizedBox(height: 16),
          AppTextfield(
            controller: priceCtrl,
            prefix: const Icon(Icons.attach_money),
            hintText: 'Price',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AppTextfield(
                  controller: stockCtrl,
                  prefix: const Icon(Icons.inventory_2),
                  hintText: 'Stock',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: AppTextfield(
                  controller: unitCtrl,
                  hintText: 'Unit',
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: image != null
                ? GestureDetector(
                    onTap: _showPreviewDialog,
                    child: Image.file(
                      File(
                        image!.path,
                      ),
                    ),
                  )
                : Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: _pickImage,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          AppTextfield(
            controller: descCtrl,
            prefix: const Icon(Icons.description),
            hintText: 'Description',
          ),
          const SizedBox(height: 16),
          AppButton(
            onPressed: _addProduct,
            child: const Text(
              'Add Product',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
