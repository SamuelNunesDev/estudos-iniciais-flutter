import 'dart:convert';
import 'dart:io';

import 'package:chat_online/firebase_service.dart';
import 'package:chat_online/notifier_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class TextComposer extends StatefulWidget {
  const TextComposer({super.key});

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  bool _isLoading = false;
  final String apiUrl = 'https://f0b06852a142.ngrok-free.app';
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  void sendMessage({XFile? imgFile}) async {
    final User? user = await FirebaseService.instance.getUser(login: true);
    if (user == null) {
      NotifierHelper.show('Houve um erro ao realizar o login do usuário.');

      return;
    }
    Map<String, dynamic> messageData = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhoto": user.photoURL,
      "time": Timestamp.now(),
    };
    // Se não for informado o arquivo de imagem e tiver algum texto digitado,
    // salva a mensagem no banco de dados e envia somente uma mensagem de texto.
    if (imgFile == null && _controller.text.isNotEmpty) {
      messageData["text"] = _controller.text;
      _controller.clear();
      setState(() {
        _isComposing = false;
      });
      // Se houver arquivo de imagem, salva o arquivo no firebase storage e grava
      // a referencia do arquivo no banco de dados.
    } else if (imgFile != null) {
      setState(() {
        _isLoading = true;
      });
      final urlImg = await uploadImg(imgFile);
      if (urlImg == null) {
        return;
      }
      messageData["url"] = urlImg;
      setState(() {
        _isLoading = false;
      });
    } else {
      return;
    }
    FirebaseService.instance.sendMessage(messageData);
  }

  Future<String?> uploadImg(XFile img) async {
    final Uri uri = Uri.parse("$apiUrl/arquivo");
    final request = http.MultipartRequest("POST", uri);
    final File file = File(img.path);
    request.files.add(await http.MultipartFile.fromPath('arquivo', file.path));
    final response = await request.send();
    if (response.statusCode != 201) {
      NotifierHelper.show('Houve um erro ao tentar enviar a imagem.');

      return null;
    }
    final String responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> data = jsonDecode(responseBody);

    return "$apiUrl/storage/${data["arquivo"]}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isLoading ? LinearProgressIndicator(color: Colors.blue) : Container(),
        Container(
          color: Color(0xFFF0F0F0),
          margin: EdgeInsets.fromLTRB(8, 0, 8, 15),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  final XFile? pickedFile = await _imagePicker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile == null) {
                    return;
                  }
                  sendMessage(imgFile: pickedFile);
                },
                icon: Icon(Icons.photo_camera),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    isCollapsed: true,
                    hintText: 'Enviar uma Mensagem...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  onSubmitted: (text) {
                    sendMessage();
                  },
                ),
              ),
              IconButton(
                onPressed: _isComposing
                    ? () {
                        sendMessage();
                        FocusScope.of(context).unfocus();
                      }
                    : null,
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
