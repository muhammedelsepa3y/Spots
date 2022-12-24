import 'package:spots_msp_project/models/events/event_model.dart';

import '../../models/chat_model/chat.dart';
// List <event_model> bikeevents=[
//   event_model(image: "bike.jpg",event_id: 20,date: "8/9/2022",location: "Giza",event_type:"Bikes" ,price:150 ),
//   event_model(image: "10.webp",event_id: 21,date: "8/20/2022",location: "Cairo", event_type:"Bikes" ,price:250),
//   event_model(image: "5.jfif",event_id: 22,date: "9/30/2022",location: "Assiut", event_type:"Bikes" ,price:250 ),
//   event_model(image: "7.jpg",event_id: 23,date: "10/10/2022",location: "Cairo",event_type:"Bikes" ,price:400 ),
//   event_model(image: "9.jpeg",event_id: 24,date: "4/20/2023",location: "New Cairo",event_type:"Cars" ,price:1000 ),
//   event_model(image: "8.jpeg",event_id: 25,date: "5/25/2023",location: "Giza",event_type:"Cars" ,price:900 ),
//   event_model(image: "6.jpg",event_id: 26,date: "7/30/2023",location: "Cairo",event_type:"Cars" ,price:850),
//   event_model(image: "1.jpeg",event_id: 27,date: "8/10/2023",location: "Assiut" ,event_type:"Cars" ,price:700),
//   event_model(image: "2.jpeg",event_id: 28,date: "9/20/2023",location: "Cairo",event_type:"Cars" ,price:600 ),
//   event_model(image: "3.jpeg",event_id: 29,date: "10/30/2023",location: "Cairo" ,event_type:"Cars" ,price:500 ),
//   event_model(image: "4.jpg",event_id: 30,date: "11/10/2023",location: "Cairo",event_type:"Cars" ,price:400 ),
//
// ];
// List<event_model> carevents=[
//   event_model(image: "9.jpeg",event_id: 13,date: "4/20/2023",location: "New Cairo",event_type:"Cars" ,price:1000 ),
//   event_model(image: "8.jpeg",event_id: 14,date: "5/25/2023",location: "Giza",event_type:"Cars" ,price:900 ),
//   event_model(image: "6.jpg",event_id: 15,date: "7/30/2023",location: "Cairo",event_type:"Cars" ,price:850 ),
//   event_model(image: "1.jpeg",event_id: 16,date: "8/10/2023",location: "Assiut", event_type:"Cars" ,price:700 ),
//   event_model(image: "2.jpeg",event_id: 17,date: "9/20/2023",location: "Cairo",event_type:"Cars" ,price:600 ),
//   event_model(image: "3.jpeg",event_id: 18,date: "10/30/2023",location: "Cairo", event_type:"Cars" ,price:500 ),
//   event_model(image: "4.jpg",event_id: 19,date: "11/10/2023",location: "Cairo",event_type:"Cars" ,price:400 ),
// ];
// List<event_model> supercarevents=[
//   event_model(image: "s.jpeg",event_id: 5,date: "8/20/2022",location: "Giza",event_type:"Cars" ,price:250 ),
//   event_model(image: "sd.jpeg",event_id: 6,date: "9/20/2022",location: "Cairo",event_type:"Cars" ,price:300 ),
//   event_model(image: "se.jpeg",event_id: 7,date: "9/30/2022",location: "Alex",event_type:"Cars" ,price:200 ),
//   event_model(image: "su.jpeg",event_id: 8,date: "10/10/2022",location: "Assiut",event_type:"Cars" ,price:250 ),
//   event_model(image: "00.jpeg",event_id: 9,date: "12/10/2022",location: "Cairo",event_type:"Cars" ,price:400 ),
//   event_model(image: "012.jpeg",event_id: 10,date: "12/25/2022",location: "Giza",event_type:"Cars" ,price:250 ),
//   event_model(image: "hey..jpeg",event_id: 11,date: "4/10/2023",location: "New Cairo",event_type:"Cars" ,price:900 ),
//   event_model(image: "supercar.jpeg",event_id: 12,date: "4/20/2023",location: "New Cairo",event_type:"Cars" ,price:1000, ),
//
// ];
// List<event_model> superbikeevents=[
//   event_model(image: "bike.jpg",event_id: 1,date: "8/9/2022",location: "Giza" ,event_type:"Bikes" ,price:150 ),
//   event_model(image: "10.webp",event_id: 2,date: "8/20/2022",location: "Cairo",event_type:"Bikes" ,price:250 ),
//   event_model(image: "5.jfif",event_id: 3,date: "9/30/2022",location: "Assiut",event_type:"Bikes" ,price:350 ),
//   event_model(image: "7.jpg",event_id: 4,date: "10/10/2022",location: "Cairo",event_type:"Bikes" ,price:400 ),
//
//
// ];
List<String>alleventime=[
  "Assets/new2.png",
  "Assets/012.jpeg",
  "Assets/00.jpeg",
  "Assets/4.jpg",
  "Assets/1.jpeg",
  "Assets/3.jpeg",
  "Assets/5.jfif",
  "Assets/6.jpg",
  "Assets/9.jpeg",
  "Assets/8.jpeg",

  "Assets/hey..jpeg",
  "Assets/new.png",
  "Assets/new3.jpeg",

  "Assets/supercar.jpeg",
  "Assets/sd.jpeg",


];

List<String>bikeimg=[
  "Assets/bike.jpg",
  "Assets/10.webp",
  "Assets/5.jfif",
  "Assets/7.jpg",



  "Assets/2.jpeg",


];
List<String>supercarimg=[
  "Assets/012.jpeg",
  "Assets/supercar.jpeg",
  "Assets/s.jpeg",
  "Assets/sd.jpeg",
  "Assets/se.jpeg",
  "Assets/su.jpeg",
  "Assets/00.jpeg",
  'Assets/hey..jpeg'
];

List<String>carimg=[
  "Assets/9.jpeg",
  "Assets/8.jpeg",
  "Assets/6.jpg",
  "Assets/1.jpeg",
  "Assets/2.jpeg",
  "Assets/3.jpeg",
  "Assets/4.jpg",];


List<String> superbikeimg=[
  "Assets/bike.jpg",
  "Assets/10.webp",
  "Assets/5.jfif",
  "Assets/7.jpg",
];
List<String> emailnames=[
"Spots","Second Spots","Third Spots","Fourth Spots","Fifth Spots","Sixth Spots","Seventh Spots","Eighth Spots","Ninth Spots","Tenth Spots"

];
List<String> message=[
"Welcome to Spots","Welcome to Second Spots","Welcome to Third Spots","Welcome to Fourth Spots","Welcome to Fifth Spots","Welcome to Sixth Spots","Welcome to Seventh Spots","Welcome to Eighth Spots","Welcome to Ninth Spots","Welcome to Tenth Spots"

];
List<String> time=[
"01:00 PM","02:00 PM","03:00 PM","04:00 PM","05:00 PM","06:00 PM","07:00 PM","08:00 PM","09:00 PM","10:00 PM"

];
List<String> img=[
"ll.jpeg","1.jpeg","2.jpeg","3.jpeg","4.jpg","6.jpg","7.jpg","8.jpeg","9.jpeg","10.webp"


];


