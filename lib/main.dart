// npx json-server --watch users.json -h 192.168.0.104 -p 3000

import 'package:http/http.dart' as http;
import 'dart:async';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:program_3/models/config.dart';
import 'package:program_3/models/users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => LoginState(), // The home route
          '/menu': (context) => Menu(), // The named route for Menu
          '/home': (context) => Home(),
          '/signup': (context) => SignUp()
        });
  }
}

class LoginState extends StatefulWidget {
  const LoginState({super.key});

  @override
  State<LoginState> createState() => _LoginStateState();
}

class _LoginStateState extends State<LoginState> {
  // Create a TextEditingController
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _alert = "";

  Users user = Users();
  @override
  void initState() {
    print("initState Called");
    // Dispose the controller when the widget is removed from the widget tree
  }

  Future<void> login() async {
    // axaxa@gmail.com
    // 1q6x5loopddf
    var params = {
      "email": _emailController.text,
      "password": _passwordController.text
    };

    print("value:${_emailController.text}");
    var url = Uri.http(Configure.server, "/users");

    var resp = await http.get(url);

    final List<dynamic> jsonList =
        jsonDecode(resp.body) ?? []; // ข้อมูลที่ได้มาเป็นลิสต์

    // login validation
    if (jsonList.isEmpty) {
      print('user-name or password are invalid');
    } else {
      print("ddd:${jsonList}");
      bool found = false;
      for (var user in jsonList) {
        if (user['email'] == _emailController.text &&
            user['password'] == _passwordController.text) {
          user = Users(
              id: int.parse(user["id"]),
              fullname: user["fullname"],
              email: user["email"],
              password: user["password"],
              gender: user["gender"]);
          Configure.login = user;
          found = true;
        }
      }
      if(found){
        Navigator.pushNamed(context, '/home');
      }else{
        setState(() {
        _alert = "อีเมลย์หรือรหัสผ่านไม่ถูกต้อง";
      });
      }
    }
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        print("Login: ${_emailController.text}");
        print("Login: ${_passwordController.text}");
        login();
      },
      child: Text("Login"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          margin: EdgeInsets.all(16.0), // Set the desired margin
          child: Row(
            children: [
              Icon(Icons.email), // Icon outside the TextFormField
              SizedBox(width: 8.0), // Space between icon and text field
              Expanded(
                child: TextFormField(
                  controller:
                      _emailController, // Attach the controller to the TextFormField
                  decoration: InputDecoration(
                      labelText: 'Email:', hintText: "Enter your email"),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(16.0), // Set the desired margin
          child: Row(
            children: [
              Icon(Icons.lock), // Icon outside the TextFormField
              SizedBox(width: 8.0), // Space between icon and text field
              Expanded(
                child: TextFormField(
                  controller:
                      _passwordController, // Attach the controller to the TextFormField
                  decoration: InputDecoration(
                      labelText: 'Password:', hintText: "Enter your password"),
                  obscureText: true, // Hide the password text
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              submitButton(),
              ElevatedButton(
                onPressed: () {
                  print("Signin");
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text("SIGN UP"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  elevation: 0, // No shadow
                  side: BorderSide.none, // No border
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity, // Make the container width 100% of its parent
          padding: EdgeInsets.all(16.0),
          child: Text(
            '$_alert',
            style: TextStyle(
              color: Colors.red,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ));
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    String accountName = "N/A";
    String accountEmail = "N/A";
    String accountUrl = "";

    String img = 'https://example.com/path-to-image.jpg';

    Users user = Configure.login;

    if (user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
      img =
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxYiRrK43q6euFKc4Dya8HFz1qLLj7twLbQ&s";
    }

    @override
    void setState() {
      print("menu-page");
      Users user = Configure.login;
      if (user.id != null) {
        return;
      }
      Navigator.pushNamed(context, '/');
    }

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text('${accountEmail}'),
            accountName: Text('${accountName}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('$img'),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              if (user.id == null) {
                Navigator.pushNamed(context, '/');
              } else {
                Navigator.pushNamed(context, '/home');
              }
              print('gonnabe crazy');
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Login'),
            onTap: () {
              // Handle Login tap
              print("hihihih");
              Users user = Users();
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
    ;
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget mainBody = Container();

  List<Users> usrs = [];

  Widget ShowUsers() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: Menu(),
      body: ListView.builder(
          itemCount: usrs.length,
          itemBuilder: (context, index) {
            Users us = usrs[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  "${us.fullname}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text("${us.email}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    print("user-edit");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditUser(),
                            settings: RouteSettings(arguments: us)));
                  },
                ),
                onTap: () {
                  print("user-info");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInfo(),
                          settings: RouteSettings(arguments: us)));
                },
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    Users user = Configure.login;
    print("this is home page");
    if (user.id != null) {
      getUserData();
    } else {
      // Navigator.pushNamed(context, "/");
    }
  }

  Future<void> getUserData() async {
    var url = Uri.http(Configure.server, "/users");
    var resp = await http.get(url);
    print("get-data");
    print(resp.body);
    final List<dynamic> jsonList =
        jsonDecode(resp.body); // ข้อมูลที่ได้มาเป็นลิสต์
    print(jsonList[0]);
    // Loop through the list and print each user
    for (var user in jsonList) {
      print('User ID: ${user["id"]}');
      print('Full Name: ${user["fullname"]}');
      print('Email: ${user["email"]}');
      print('Password: ${user["password"]}');
      print('Gender: ${user["gender"]}');
      print('---');
      if (int.parse(user["id"]) == Configure.login.id) continue;
      usrs.add(Users(
          id: int.parse(user["id"]),
          fullname: user["fullname"],
          email: user["email"],
          password: user["password"],
          gender: user["gender"]));
    }
    setState(() {
      mainBody = ShowUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return mainBody;
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  int? id = null;
  Future<void> deleteData() async {
    print("id: $id");
    // Check if id is not null
    if (id != null) {
      // id is not null, safe to use
      var url1 = Uri.http(Configure.server, "/users/$id");
      var headers = {"Content-Type": "application/json"};

      var resp1 = await http.delete(url1, headers: headers);
      print('done....');
      Navigator.pushNamed(context, '/home');
    } else {
      // id is null
      print('ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Users us = ModalRoute.of(context)!.settings.arguments as Users;

    if (us.id != null) {
      id = us.id!;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('User Info'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Full Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text("${us.fullname}"),
                ),
                ListTile(
                  title: Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text("${us.email}"),
                ),
                ListTile(
                  title: Text(
                    "Gender",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text("${us.gender}"),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.pop(context, 'OK');
                    deleteData();
                    print("ลบ");
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue, // Default background color
                      foregroundColor: Colors.white),
                  child: const Text('ลบข้อมูล'),
                )
              ],
            )));
  }
}

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  String _fullname = '';
  String _email = '';
  String _password = '';
  String _gender = 'None';
  late int _id;

  String _alert = "";

  Future<void> updateData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var body = {
        "fullname": '$_fullname',
        "email": '$_email',
        "password": '$_password',
        "gender": '$_gender'
      };
      var url1 = Uri.http(Configure.server, "/users/$_id");
      var headers = {"Content-Type": "application/json"};
      // var resp = await http.post(url);
      var jsonBody = jsonEncode(body);

      var resp1 = await http.put(url1, headers: headers, body: jsonBody);

      print("resp:${resp1.body}");
      print('done....');
      setState(() {
        _alert = "อัพเดทข้อมูลเรียบร้อย";
      });
      Navigator.pushNamed(
        context,
        '/home',
        arguments: 'อัพเดทข้อมูลเรียบร้อย',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Users us = ModalRoute.of(context)!.settings.arguments as Users;

    if (us.id != null) {
      _id = us.id!;
      _fullname = us.fullname!;
      _email = us.email!;
      _password = us.password!;
      _gender = us.gender!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _fullname,
                decoration: InputDecoration(
                  labelText: 'Fullname:',
                  icon: Icon(Icons.person),
                ),
                onSaved: (value) {
                  _fullname = value!;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email:',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                initialValue: _password,
                decoration: InputDecoration(
                  labelText: 'Password:',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                onSaved: (value) {
                  _password = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender:',
                  icon: Icon(Icons.person_outline),
                ),
                value: _gender,
                items: ['None', 'Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  print('select:${newValue}');
                  setState(() {
                    _gender = newValue!;
                  });
                },
                onSaved: (value) {
                  _gender = value!;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("update");
                      _formKey.currentState!.save();
                      updateData();
                    }
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _fullname = '';
  String _email = '';
  String _password = '';
  String _gender = 'None';

  String _alert = "";

  Future<void> signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform save operation
      print('Fullname: $_fullname');
      print('Email: $_email');
      print('Password: $_password');
      print('Gender: $_gender');

      var url = Uri.http(Configure.server, "/users");
      var resp = await http.get(url);

      final List<dynamic> jsonList =
          jsonDecode(resp.body); // ข้อมูลที่ได้มาเป็นลิสต์
      print(jsonList[0]);

      // Ensure jsonList is a list of maps
      if (jsonList.isNotEmpty) {
        // Convert IDs to integers and find the maximum ID
        int maxId = jsonList
            .map((user) => int.parse(user["id"] as String))
            .reduce((a, b) => a > b ? a : b);

        // Find the user with the maximum ID
        String? maxUserId = jsonList.firstWhere(
          (user) => int.parse(user["id"] as String) == maxId,
          orElse: () => {},
        )["id"] as String?;
        int maxID = int.parse(maxUserId!) + 1;
        var body = {
          "id": "${maxID}",
          "fullname": '$_fullname',
          "email": '$_email',
          "password": '$_password',
          "gender": '$_gender'
        };
        var url1 = Uri.http(Configure.server, "/users", body);
        var headers = {"Content-Type": "application/json"};
        // var resp = await http.post(url);
        var jsonBody = jsonEncode(body);

        var resp1 = await http.post(url1, headers: headers, body: jsonBody);

        print("resp:${resp1.body}");
        print('done....');

        setState(() {
          _alert = "เพิ่มสมาชิคเรียบร้อย";
        });

        // Print the ID of the user with the maximum ID
        print("ID of user with max ID: $maxUserId");
      } else {
        print("No users found.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _fullname,
                decoration: InputDecoration(
                  labelText: 'Fullname:',
                  icon: Icon(Icons.person),
                ),
                onSaved: (value) {
                  _fullname = value!;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email:',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                initialValue: _password,
                decoration: InputDecoration(
                  labelText: 'Password:',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                onSaved: (value) {
                  _password = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender:',
                  icon: Icon(Icons.person_outline),
                ),
                value: _gender,
                items: ['None', 'Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    signup();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              Text(
                '$_alert',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
