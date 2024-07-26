import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  int count=0;
  List<Message> _messages = [
    Message(isMe:false, text:"this is a calculator"),
    Message(isMe:true, text:"Just type your expression"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageWidget(message:_messages[index]);
              },
            ),
          ),
          InputWidget(
            onSendMessage: (String message) {
              setState(() {
                count++;
                if(count%2==0)
                  _messages.add(Message(isMe:false, text: message));
                else
                  _messages.add(Message(isMe:true, text: message));
              });
            },
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isMe;
  final String text;

  Message({required this.isMe,required this.text});
}

class MessageWidget extends StatelessWidget {
  final Message message;

  MessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue : Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class InputWidget extends StatefulWidget {
  final Function(String) onSendMessage;

  InputWidget({required this.onSendMessage});

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _textController = TextEditingController();
  String res="";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)))
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              String message = _textController.text;
              if (message.isNotEmpty) {
                widget.onSendMessage(message);
                _textController.clear();
                Parser p = Parser();
                Expression exp = p.parse(message);
                ContextModel cm = ContextModel();

                double eval = exp.evaluate(EvaluationType.REAL, cm);
                try {
                  widget.onSendMessage(eval.toString());
                }
                catch(e)
                {
                  widget.onSendMessage("error");
                }
              }

            },
          ),
        ],
      ),
    );
  }
}
