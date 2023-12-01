
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var profile = "https://avatars.githubusercontent.com/u/86506519?v=4";

List populars = [
  {
    "image": "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Villa simple",
    "price": "25000F / jour",
    "location": "1200 logement, Ouagadougou",
    "is_favorited": true,
  },
  {
    "image": "https://images.unsplash.com/photo-1598928506311-c55ded91a20c?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Résidence Maeva",
    "price": "11000F / heure",
    "location": "Saaba, Ouagadougou",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1576941089067-2de3c901e126?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Résidence Alice",
    "price": "8000F / heure",
    "location": "Karpala, Ouagadougou",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Studio meublé",
    "price": "17000F / heure",
    "location": "Ouaga 2000, Ouagadougou",
    "is_favorited": false,
  },
];

List recommended = [
  {
    "image": "https://images.unsplash.com/photo-1592595896616-c37162298647?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Résidence Alice",
    "price": "8000F / heure",
    "location": "Phnom Penh",
    "is_favorited": true,
  },
  {
    "image": "https://images.unsplash.com/photo-1576941089067-2de3c901e126?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Résidence Maeva",
    "price": "17000F / heure",
    "location": "Karpala, Ouagadougou",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Chambre hôtel yilmdé",
    "price": "7000F / heure",
    "location": "Goughin, Ouagadoudou",
    "is_favorited": true,
  },
];

List recents = [
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Phnom Penh",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1598928506311-c55ded91a20c?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Résidence Ariel",
    "price": "7000F / heure",
    "location": "Karpala, Ouagadougou",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1576941089067-2de3c901e126?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Chambre hôtel yilmdé",
    "price": "7000F / heure",
    "location": "Goughin, Ouagadoudou",
    "is_favorited": false,
  },
];

List categories = [
  {
    "name" : "Tout",
    "icon" :  FontAwesomeIcons.boxes
  },
  {
    "name" : "Villa",
    "icon" :  FontAwesomeIcons.university
  },
  {
    "name" : "Appart.",
    "icon" :  FontAwesomeIcons.storeAlt
  },
  {
    "name" : "Hôtel",
    "icon" :  FontAwesomeIcons.building
  },
  {
    "name" : "Maison",
    "icon" :  FontAwesomeIcons.home
  },
];

var brokers = [
    {
    "image": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjV8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60", 
    "name": "John Siphron", 
    "type": "Broker", 
    "description": "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4, 
  },
  {
    "image":"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name" : "Corey Aminoff",
    "type": "Broker", 
    "description": "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4, 
  },
];

List companies = [
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "TS Home",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": false,
    "icon" : Icons.domain_rounded
  },
  {
    "image": "https://images.unsplash.com/photo-1618221469555-7f3ad97540d6?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Century 21",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon" : Icons.house_siding_rounded
  },
  {
    "image": "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Dabest Pro",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon" : Icons.home_work_rounded
  },
  {
    "image": "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Cam Reality",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon" : Icons.location_city_rounded
  },
];