import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainAreaForums extends StatelessWidget {
  const MainAreaForums({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          //Row -1- Lighting Type
          Text(
            'Lighting Type',
            style: GoogleFonts.firaSans(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 65,
            child: TextField(
              expands: true,
              maxLines: null,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "e.g Fluorecent",
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500, //meduim w500
                  color: Color(0xFF808080),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          //Row -2- Rated Power(W) , NO of lights
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rated Power (W)',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  'No of lights',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          //textfields for the Row -2-
          Row(
            children: [
              SizedBox(
                height: 65,
                child: TextField(
                  expands: true,
                  maxLines: null,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "e.g 36",
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500, //meduim w500
                      color: Color(0xFF808080),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF808080),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF808080),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 65,
                child: TextField(
                  expands: true,
                  maxLines: null,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "e.g 120",
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500, //meduim w500
                      color: Color(0xFF808080),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF808080),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF808080),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          //Row -3- -------------->
          Text(
            'Yearly operating hours',
            style: GoogleFonts.firaSans(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 65,
            child: TextField(
              expands: true,
              maxLines: null,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "e.g 1200",
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500, //meduim w500
                  color: Color(0xFF808080),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),

          //Row -4- ------------------------->
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Power (kW)',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  'Annual (kW/yr)',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          //textfields for the Row -4-
          Row(
            children: [
              SizedBox(
                height: 65,
                child: TextField(
                  readOnly: true,
                  expands: true,
                  maxLines: null,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "----",
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500, //meduim w500
                      color: Color(0xFF808080),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF808080),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF808080),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 65,
                child: TextField(
                  readOnly: true,
                  expands: true,
                  maxLines: null,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "----",
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500, //meduim w500
                      color: Color(0xFF808080),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF808080),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF808080),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

