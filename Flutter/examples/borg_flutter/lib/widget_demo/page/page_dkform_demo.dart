import 'dart:convert';

import 'package:borg_flutter/widget/dk_form.dart';
import 'package:borg_flutter/widget/dk_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

class DkFormDemoPage extends StatefulWidget {
  static const String routeName = '/page/dkform_demo_page';
  static const String name = "DkFormDemoPage";

  @override
  _FormDemoState createState() => _FormDemoState();
}

class _FormDemoState extends State<DkFormDemoPage> {
  GlobalKey<DkFormState> _formKey = GlobalKey<DkFormState>();

  String _name;
  String _password;
  String _common;

  void _forSubmitted() {
    var _form = _formKey.currentState;

    if (_form.validate()) {
      _form.save();
      print(_name);
      print(_password);
      print(_common);
      print(_form.value);
      print(json.encode(_form.value));
    }
  }

  void _forReset() {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: 'reset',
      currentButton: FloatingActionButton(
        heroTag: 'reset',
        backgroundColor: Colors.redAccent,
        mini: true,
        child: Icon(Icons.train),
        onPressed: _forReset,
      ),
    ));
    childButtons.add(UnicornButton(
      currentButton: FloatingActionButton(
        child: Text('Save'),
        onPressed: _forSubmitted,
      ),
    ));

    return MaterialApp(
      title: 'Flutter data',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Form'),
        ),
        floatingActionButton: UnicornDialer(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
            parentButtonBackground: Colors.redAccent,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.add),
            childButtons: childButtons
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: DkForm(
            key: _formKey,
            child: Column(
              children: <Widget>[
                LanguageSelect(),
                DropdownWidget(),
                DkTextFormField(
                  attribute: 'name',
                  initialValue: 'gulliver',
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                  ),
                  onSaved: (val) {
                    _name = val;
                  },
                ),
                DkTextFormField(
                  attribute: 'pwd',
                  initialValue: '123456',
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (val) {
                    return val.length < 4 ? "密码长度错误" : null;
                  },
                  onSaved: (val) {
                    _password = val;
                  },
                ),
                Container(
                  child: DkTextFormField(
                    attribute: 'context',
                    initialValue: 'danke',
                    autovalidate: true,
                    decoration: InputDecoration(
                      labelText: 'Common',
                    ),
                    validator: (val) {
                      return val.length < 4 ? "密码长度错误" : null;
                    },
                    onSaved: (val) {
                      _common = val;
                    },
                    onFieldSubmitted: (val) {
                      print(val);
                    },
                  ),
                ),
                DkFormFieldGroup(
                  attribute: 'group',
                  child: Column(
                    children: <Widget>[
                      DkTextFormField(
                        attribute: 'groupname',
                        initialValue: 'gulliver-group',
                        decoration: InputDecoration(
                          labelText: 'group Your Name',
                        ),
                        onSaved: (val) {
                          _name = val;
                        },
                      ),
                      Container(
                        child: DkTextFormField(
                          attribute: 'grouppwd',
                          initialValue: '987654',
                          decoration: InputDecoration(
                            labelText: 'group password',
                          ),
                          validator: (val) {
                            return val.length < 4 ? "密码长度错误" : null;
                          },
                          onSaved: (val) {
                            _name = val;
                          },
                        ),
                      ),
                      DkFormFieldGroup(
                        attribute: 'favarite',
                        child: Column(
                          children: <Widget>[
                            DkTextFormField(
                              attribute: 'favarite name',
                              initialValue: '地心历险记',
                              decoration: InputDecoration(
                                labelText: 'favarite name',
                              ),
                              onSaved: (val) {
                                _name = val;
                              },
                            ),
                          ],
                        ),
                      ),
                      MovieForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DkFormField(
      initialValue: 'Two',
      attribute: 'drop_down_name',
      validator: (value) {
        return value == 'One' ? "密码长度错误" : null;
      },
      builder: (DkFormFieldState<dynamic> field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select option',
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
            border: InputBorder.none,
            errorText: field.errorText,
          ),
          child: DropdownButton(
            isExpanded: true,
            items: ["One", "Two"].map((option) {
              return DropdownMenuItem(
                child: Text("$option"),
                value: option,
              );
            }).toList(),
            value: field.value,
            onChanged: (value) {
              field.didChange(value);
            },
          ),
        );
      },
    );
  }
}

class LanguageSelect extends StatelessWidget {
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
  GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return DkFormField(
      valueTransformer: (value){
        if(value == 'Other')
        {
          value = _specifyTextFieldKey.currentState.value;
        }
        return value;
      },
      attribute: 'language',
      builder: (DkFormFieldState<String> field) {
        var languages = ["English", "Spanish", "Somali", "Other"];
        return InputDecorator(
          decoration:
              InputDecoration(labelText: "What's your preferred language?"),
          child: Column(
            children: languages
                .map(
                  (lang) => Row(
                    children: <Widget>[
                      Radio<dynamic>(
                        value: lang,
                        groupValue: field.value,
                        onChanged: (dynamic value) {
                          field.didChange(value);
                        },
                      ),
                      lang != 'Other'
                          ? Text(lang)
                          : Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(lang),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(key: _specifyTextFieldKey),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                )
                .toList(growable: false),
          ),
        );
      },
    );
  }
}

class MovieForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DkFormFieldList(
      attribute: 'movie',
      child: Column(
        children: <Widget>[
          DkFormFieldListItem(
            child: Column(
              children: <Widget>[
                DkTextFormField(
                  attribute: 'name',
                  initialValue: '双面杀手',
                  decoration: InputDecoration(
                    labelText: '电影名称',
                  ),
                ),
                DkTextFormField(
                  attribute: 'nation',
                  initialValue: '美国',
                  decoration: InputDecoration(
                    labelText: '地区',
                  ),
                ),
              ],
            ),
          ),
          DkFormFieldListItem(
            child: Column(
              children: <Widget>[
                DkTextFormField(
                  attribute: 'name',
                  initialValue: '我的国',
                  decoration: InputDecoration(
                    labelText: '电影名称',
                  ),
                ),
                DkTextFormField(
                  attribute: 'nation',
                  initialValue: '中国',
                  decoration: InputDecoration(
                    labelText: '地区',
                  ),
                ),
                DkFormFieldGroup(
                  attribute: 'favarite2',
                  child: Column(
                    children: <Widget>[
                      DkTextFormField(
                        attribute: 'favarite name',
                        initialValue: '地心历险记2',
                        decoration: InputDecoration(
                          labelText: 'favarite name',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
