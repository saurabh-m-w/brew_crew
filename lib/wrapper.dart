import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';
import 'home/Home.dart';
import 'modules/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user =Provider.of<User>(context);
    print(user);
    if(user==null)
      return Authenticate();
    else
      return Home();
  }
}
