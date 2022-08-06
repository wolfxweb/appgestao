import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';

class simulador_new extends StatefulWidget {
  const simulador_new({Key? key}) : super(key: key);

  @override
  State<simulador_new> createState() => _simulador_newState();
}

class _simulador_newState extends State<simulador_new> {
  final _formKey = GlobalKey<FormState>();
  var corFundo = Colors.grey[150];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Simulador new",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        //  elevation: 15,
        //  toolbarHeight: 100, // default is 56
        //  toolbarOpacity: 0.5,
      ),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 190,
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  TextEditingController(text: "R\$ 3.650,00"),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                // suffixIcon: suffixIcon,
                                fillColor: corFundo,
                                filled: true,
                                // disabledBorder: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 1.0,
                                      style: BorderStyle.none),
                                ),
                                border: InputBorder.none,

                                labelText: "Vendas",
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  //  backgroundColor: Colors.white,
                                ),
                                // hintText: 'Quantidade de clientes atendidos',
                              ),
                              onChanged: null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: "10"),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  suffixIcon: const Icon(
                                    Icons.percent,
                                    color: Colors.black54,
                                    size: 16.0,
                                  ),
                                  fillColor: Colors.orangeAccent[100],
                                  filled: true,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange,
                                        width: 1.0,
                                        style: BorderStyle.none),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "",
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    //  backgroundColor: Colors.white,
                                  ),
                                  // hintText: 'Quantidade de clientes atendidos',
                                ),
                                onChanged: null,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 195,
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  TextEditingController(text: "R\$ 3.650,00"),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                // suffixIcon: suffixIcon,
                                fillColor: corFundo,
                                filled: true,
                                // disabledBorder: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 1.0,
                                      style: BorderStyle.none),
                                ),
                                border: InputBorder.none,
                                labelText: "Ticket Méidio",
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  //  backgroundColor: Colors.white,
                                ),
                                // hintText: 'Quantidade de clientes atendidos',
                              ),
                              onChanged: null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 130,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller:
                                              TextEditingController(text: "10"),
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 5),
                                            suffixIcon: const Icon(
                                              Icons.percent,
                                              color: Colors.black54,
                                              size: 16.0,
                                            ),
                                            fillColor: Colors.orangeAccent[100],
                                            filled: true,
                                            disabledBorder: InputBorder.none,
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orange,
                                                  width: 1.0,
                                                  style: BorderStyle.none),
                                            ),
                                            border: InputBorder.none,

                                            labelText: "",
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                              //  backgroundColor: Colors.white,
                                            ),
                                            // hintText: 'Quantidade de clientes atendidos',
                                          ),
                                          onChanged: null,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 190,
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  TextEditingController(text: "R\$ 3.650,00"),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                // suffixIcon: suffixIcon,
                                fillColor: corFundo,
                                filled: true,
                                // disabledBorder: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 1.0,
                                      style: BorderStyle.none),
                                ),
                                border: InputBorder.none,

                                labelText: "Vendas",
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  //  backgroundColor: Colors.white,
                                ),
                                // hintText: 'Quantidade de clientes atendidos',
                              ),
                              onChanged: null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: "10"),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  suffixIcon: const Icon(
                                    Icons.percent,
                                    color: Colors.black54,
                                    size: 16.0,
                                  ),
                                  fillColor: Colors.orangeAccent[100],
                                  filled: true,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange,
                                        width: 1.0,
                                        style: BorderStyle.none),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "",
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    //  backgroundColor: Colors.white,
                                  ),
                                  // hintText: 'Quantidade de clientes atendidos',
                                ),
                                onChanged: null,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 195,
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  TextEditingController(text: "R\$ 3.650,00"),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                // suffixIcon: suffixIcon,
                                fillColor: corFundo,
                                filled: true,
                                // disabledBorder: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 1.0,
                                      style: BorderStyle.none),
                                ),
                                border: InputBorder.none,
                                labelText: "Ticket Méidio",
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  //  backgroundColor: Colors.white,
                                ),
                                // hintText: 'Quantidade de clientes atendidos',
                              ),
                              onChanged: null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: "10"),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  suffixIcon: const Icon(
                                    Icons.percent,
                                    color: Colors.black54,
                                    size: 16.0,
                                  ),
                                  fillColor: Colors.orangeAccent[100],
                                  filled: true,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange,
                                        width: 1.0,
                                        style: BorderStyle.none),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "",
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    //  backgroundColor: Colors.white,
                                  ),
                                  // hintText: 'Quantidade de clientes atendidos',
                                ),
                                onChanged: null,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 190,
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  TextEditingController(text: "R\$ 3.650,00"),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                // suffixIcon: suffixIcon,
                                fillColor: corFundo,
                                filled: true,
                                // disabledBorder: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 1.0,
                                      style: BorderStyle.none),
                                ),
                                border: InputBorder.none,

                                labelText: "Vendas",
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  //  backgroundColor: Colors.white,
                                ),
                                // hintText: 'Quantidade de clientes atendidos',
                              ),
                              onChanged: null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: "10"),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  suffixIcon: const Icon(
                                    Icons.percent,
                                    color: Colors.black54,
                                    size: 16.0,
                                  ),
                                  fillColor: Colors.orangeAccent[100],
                                  filled: true,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange,
                                        width: 1.0,
                                        style: BorderStyle.none),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "",
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    //  backgroundColor: Colors.white,
                                  ),
                                  // hintText: 'Quantidade de clientes atendidos',
                                ),
                                onChanged: null,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 195,
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  TextEditingController(text: "R\$ 37.650,00"),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                // suffixIcon: suffixIcon,
                                fillColor: corFundo,
                                filled: true,
                                // disabledBorder: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 1.0,
                                      style: BorderStyle.none),
                                ),
                                border: InputBorder.none,
                                labelText: "Ticket Méidio",
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  //  backgroundColor: Colors.white,
                                ),
                                // hintText: 'Quantidade de clientes atendidos',
                              ),
                              onChanged: null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: "10"),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  suffixIcon: const Icon(
                                    Icons.percent,
                                    color: Colors.black54,
                                    size: 16.0,
                                  ),
                                  fillColor: Colors.orangeAccent[100],
                                  filled: true,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange,
                                        width: 1.0,
                                        style: BorderStyle.none),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "",
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    //  backgroundColor: Colors.white,
                                  ),
                                  // hintText: 'Quantidade de clientes atendidos',
                                ),
                                onChanged: null,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 195,
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  TextEditingController(text: "R\$ 31.650,00"),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                // suffixIcon: suffixIcon,
                                fillColor: corFundo,
                                filled: true,
                                // disabledBorder: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 1.0,
                                      style: BorderStyle.none),
                                ),
                                border: InputBorder.none,
                                labelText:
                                    "Adiconado apenas para validar o layout",
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  //  backgroundColor: Colors.white,
                                ),
                                // hintText: 'Quantidade de clientes atendidos',
                              ),
                              onChanged: null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: BorderRadius.zero,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: "10"),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  icon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                      size: 20.0,
                                    ),
                                  ),
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 20.0,
                                    ),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.percent,
                                    color: Colors.black54,
                                    size: 16.0,
                                  ),
                                  //  fillColor: corFundo,
                                  //   filled: true,
                                  // disabledBorder: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange,
                                        width: 1.0,
                                        style: BorderStyle.none),
                                  ),
                                  border: InputBorder.none,
                                  //    labelText: "ps",
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    //  backgroundColor: Colors.white,
                                  ),
                                  // hintText: 'Quantidade de clientes atendidos',
                                ),
                                onChanged: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller:
                              TextEditingController(text: "R\$ 31.650,00"),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            // suffixIcon: suffixIcon,
                            fillColor: corFundo,
                            filled: true,
                            // disabledBorder: true,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 1.0,
                                  style: BorderStyle.none),
                            ),
                            border: InputBorder.none,
                            labelText: "Adiconado apenas para validar o layout",
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              //  backgroundColor: Colors.white,
                            ),
                            // hintText: 'Quantidade de clientes atendidos',
                          ),
                          onChanged: null,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent[100],
                            borderRadius: BorderRadius.zero,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: "10"),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 5),
                              icon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                  size: 20.0,
                                ),
                              ),
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                              ),
                              suffixIcon: const Icon(
                                Icons.percent,
                                color: Colors.black54,
                                size: 16.0,
                              ),
                              //  fillColor: corFundo,
                              //   filled: true,
                              // disabledBorder: true,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange,
                                    width: 1.0,
                                    style: BorderStyle.none),
                              ),
                              border: InputBorder.none,
                              //    labelText: "ps",
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                //  backgroundColor: Colors.white,
                              ),
                              // hintText: 'Quantidade de clientes atendidos',
                            ),
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _styleInput(String text, String cor, suffixIcon) {
    switch (cor) {
      case "padrao":
        corFundo = Colors.orangeAccent[100];
        break;
      case 'desabilitado':
        corFundo = Colors.grey[100];
        break;
      case 'vermelho':
        corFundo = Colors.red[200];
        break;
      case 'verde':
        corFundo = Colors.green[200];
        break;
    }

    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      suffixIcon: suffixIcon,
      fillColor: corFundo,
      filled: true,

      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.orange, width: 1.0, style: BorderStyle.none),
      ),
      border: InputBorder.none,
      labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,
        //  backgroundColor: Colors.white,
      ),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }
}
