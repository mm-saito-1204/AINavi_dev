import "dart:convert";
import 'dart:math';
import 'package:ainavi/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import "package:http/http.dart" as http;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/* 
 * チャット画面
 */
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

/*
 * チャットルーム画面を生成するクラス
 */
class TabPageAIChat extends StatefulWidget {
  const TabPageAIChat({Key? key}) : super(key: key);

  @override
  State<TabPageAIChat> createState() => TabPageAIChatState();
}

/*
 * チャットルーム画面ウィジェットのクラス
 */
class TabPageAIChatState extends State<TabPageAIChat> {
  final List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
  final _ai = const types.User(
    id: 'otheruser',
    imageUrl:
        'https://1.bp.blogspot.com/-eYbEtYcQHL8/XnLn6Fy-tOI/AAAAAAABX0c/O5NnoOqVissoS0-i0PCu3ZANBSHYFzrSACNcBGAsYHQ/s1600/character_social_robot.png',
  );
  bool isFirst = true;
  String returnMessageText = "";
  List<bool> isSelected = [true, false];
  bool isQuestion = true;

  @override
  void initState() {
    super.initState();
    _instructionMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          width: SizeConfig.safeBlockHorizontal * 100,
          height: SizeConfig.safeBlockVertical * 7,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(10, 1),
                color: Colors.grey,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.center,
                height: SizeConfig.blockSizeVertical * 7,
                width: SizeConfig.blockSizeHorizontal * 65.9,
                color: Colors.blue[100],
                child: const Text(
                  ' AIにチャットで相談しよう！',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ToggleButtons(
                borderRadius: BorderRadius.circular(2.0),
                fillColor: Colors.blue[300],
                isSelected: isSelected,
                onPressed: (index) {
                  setState(() {
                    if ((index == 0 && !isQuestion) ||
                        (index == 1 && isQuestion)) {
                      isSelected[0] = !isSelected[0];
                      isSelected[1] = !isSelected[1];
                      isQuestion = !isQuestion;
                      _instructionMessage();
                    }
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('質問'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('添削'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Chat(
            user: _user,
            showUserAvatars: true,
            messages: _messages,
            onSendPressed: _handleSendPressed,
            l10n: ChatL10nEn(
              emptyChatPlaceholder: isQuestion
                  ? 'メッセージがありません。\nAIに質問してみましょう'
                  : 'メッセージがありません。\nAIに添削依頼をしてみましょう',
              inputPlaceholder: isQuestion ? 'AIに質問する' : 'AIに添削依頼する',
            ),
            theme: const DefaultChatTheme(
              sentMessageBodyTextStyle:
                  TextStyle(color: Colors.black, fontSize: 16),
              primaryColor: Color.fromARGB(255, 142, 234, 250),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSendPressed(types.PartialText message) async {
    returnMessageText = "";

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    setState(() {
      _messages.insert(0, textMessage);
    });

    final returnMessage = types.TextMessage(
      author: _ai,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: "AIが回答を入力中...",
    );
    setState(() {
      _messages.insert(0, returnMessage);
    });
    String sendMessageText = isQuestion
        ? 'あなたは日本語で就職活動について質問されます。あなたはエキスパートです。以下の質問に答えてください。\n${message.text}'
        : 'あなたは、日本語で就職活動に関する文章の添削依頼をされます。あなたはエキスパートです。添削時は、「二重敬語・控えるべき言葉・結論ファースト」の点に注意してください。また、「御社」は正しい言葉です。\n\n以下の添削依頼に、「添削後の文章」と「アドバイス」の構成で答えてください。\n${message.text}';
    sendChatCompletionRequest(sendMessageText);
  }

  _instructionMessage() {
    if (isFirst) {
      isFirst = false;
      final firstMessage = types.TextMessage(
        author: _ai,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: 'AIチャットへようこそ！\nここでは、私に質問や添削依頼ができます。\n右上のボタンで質問・添削を切り替えられるよ！',
      );
      setState(() {
        _messages.insert(0, firstMessage);
      });
    } else {
      final returnMessage = types.TextMessage(
        author: _ai,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: isQuestion
            ? '就職活動に関することなら私になんでも質問してください！'
            : '添削依頼は下記のフォーマットをコピーして記述してください！\n\n文章の使用場面：\n添削後の希望文字数：\n添削する文章：\n\n例）\n文書の使用場面：面接(志望動機)\n添削後の希望文字数200\n添削する文章：私が御社を志望した理由は〜〜〜〜',
      );
      setState(() {
        _messages.insert(0, returnMessage);
      });
    }
  }

  /*
   * chatgpt-API アクセス
   */
  void sendChatCompletionRequest(String text) {
    final client = http.Client();

    var request = http.Request(
      'POST',
      Uri.parse('https://api.openai.com/v1/chat/completions'),
    );

    Map<String, String> header = {
      'accept': 'text/event-stream',
      'Authorization': 'Bearer ${dotenv.env['OPENAI_APIKEY']!}',
      'Content-Type': 'application/json'
    };

    header.forEach((key, value) {
      request.headers[key] = value;
    });

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": text},
      ],
      "stream": true
    };

    request.body = jsonEncode(body);

    Future<http.StreamedResponse> response = client.send(request);

    response.asStream().listen((data) {
      // ByteStreamをStringに変換し、改行で分割して1行ずつ処理する
      data.stream
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(
        (dataLine) {
          // dataLineが空の場合や、[DONE]が返ってきた場合は早期リターン
          if (dataLine.isEmpty) {
            return;
          } else if (dataLine == 'data: [DONE]') {
            setState(() {
              final returnMessage = types.TextMessage(
                author: _ai,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: randomString(),
                text: returnMessageText,
              );
              // _messages.first = returnMessage;
              _messages.first = returnMessage;
            });
            return;
          }

          // dataLineの中身は'data: 'で始まっているので、それを削除してからMapに変換
          final map = dataLine.replaceAll('data: ', '');
          Map<String, dynamic> data = json.decode(map);
          // finish_reasonがstopの場合は早期リターン
          if (data['choices'][0]['finish_reason'] == 'stop') {
            return;
          }

          // 'content'を取得して文字列を追加していく
          List<dynamic> choices = data["choices"];
          Map<String, dynamic> choice = choices[0];
          Map<String, dynamic> delta = choice["delta"];
          String content = delta["content"];

          returnMessageText += content;

          // final returnMessage = types.TextMessage(
          //   author: _ai,
          //   createdAt: DateTime.now().millisecondsSinceEpoch,
          //   id: randomString(),
          //   text: returnMessageText,
          // );
          // setState(() {
          //   _messages[0] = returnMessage;
          // });
        },
      );
    });
  }
}
