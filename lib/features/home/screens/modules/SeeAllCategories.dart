import 'package:flutter/material.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 15,
        right: 15,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Explore By Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          InkWell(
            
            child: Text('See All>',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0XFF010d75))),
          ),
        ],
      ),
    );
  }
}
