import 'package:cloud_firestore/cloud_firestore.dart';

class usuariosfb {


  listaUsuarios() async {
    await FirebaseFirestore.instance
        .collection('usuario')
        .get()
        .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {
        print(doc);
      });
    });
  }
}
