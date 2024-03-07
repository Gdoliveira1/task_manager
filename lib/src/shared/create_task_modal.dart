import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:task_manager/src/domain/constants/app_colors.dart";

class CreateTaskModal extends StatefulWidget {
  final Function(String name, DateTime dateTime, File? image) onCreateTask;

  const CreateTaskModal({required this.onCreateTask, super.key});

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _taskName = "";
  late DateTime _selectedDate = DateTime.now();
  File? _selectedImage;

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.onCreateTask(_taskName, _selectedDate, _selectedImage);
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.whiteSmoke,
      title: const Text("Adicionar Tarefa"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Nome da Tarefa"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Por favor, digite o nome da tarefa";
                  }
                  return null;
                },
                onSaved: (value) {
                  _taskName = value!;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text("Selecionar Data"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_selectedImage != null) ...[
                Text("Imagem selecionada: ${_selectedImage!.path}"),
              ],
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Text(
                    "Adicionar Imagem",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text("Salvar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.whisper,
                    ),
                    child: const Text("Cancelar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
