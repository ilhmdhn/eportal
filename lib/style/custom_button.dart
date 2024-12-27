import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:flutter/material.dart';

class CustomButton{
  static Widget cancel(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 0.4, 
        color: Colors.red)),
      child: Row(
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 19),
          const SizedBox(width: 3,),
          Text('Batalkan', style: CustomFont.headingLimaRed(),),
        ],
      ),
    );
  }

  static Widget edit(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(width: 0.4, 
          color: Colors.amber.shade900)),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.amber.shade900
            ),
            child: const Center(
              child: Icon(
                Icons.edit,
                size: 11,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          AutoSizeText(
            'Ubah',
            style: CustomFont.headingLimaAmber(),
          )
        ],
      ),
    );
  }
}