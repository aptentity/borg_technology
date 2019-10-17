import 'package:borg_flutter/widget/dk_form.dart';
import 'package:borg_flutter/widget/dk_text_form_field.dart';
import 'package:flutter/material.dart';

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter data',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Form'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _forSubmitted,
          child:  Text('提交'),
        ),
        body:  Container(
          padding: const EdgeInsets.all(16.0),
          child: DkForm(
            key: _formKey,
            child:  Column(
              children: <Widget>[
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
                    onFieldSubmitted: (val){
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
                        child:DkTextFormField(
                          attribute: 'grouppwd',
                          initialValue: '987654',
                          decoration: InputDecoration(
                            labelText: 'group password',
                          ),
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