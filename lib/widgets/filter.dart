import 'package:flutter/material.dart';

class Filter extends StatelessWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueGrey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadiusDirectional.circular(2.5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Text(
              'Filtros',
              textAlign: TextAlign.left,
              textScaleFactor: 2,
            ),
          ),
        ],
      ),
    );
  }
}
