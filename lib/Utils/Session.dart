Map<String, String> get headers => {
  "Authorization": 'Bearer ',
};

Map<String, String> get headersUsers => {
  "Content-Type": 'application/x-www-form-urlencoded ',
};

String? validatePass(String value, String msg1, String msg2){
  if(value.length == 0)
    return msg1;
  else if(value.length <=5)
    return msg2;
  else
    return null;
}

String? validateUserName(String value, String msg1){
  if(value.length == 0)
    return msg1;
  else
    return null;
}