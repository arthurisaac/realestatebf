import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/utils/constants.dart';
import 'package:http/http.dart';
import 'package:realestatebf/utils/ui_utils.dart';

import '../utils/api_utils.dart';
import 'choose_coordonates_screen.dart';

class EditPropertyScreen extends StatefulWidget {
  final Property property;

  const EditPropertyScreen({Key? key, required this.property}) : super(key: key);

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  TextEditingController nomController = TextEditingController(text: "");
  TextEditingController quartierController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");

  TextEditingController superficieController = TextEditingController(text: "");
  TextEditingController nombreChambreController = TextEditingController(text: "");
  TextEditingController nombreBainController = TextEditingController(text: "");
  TextEditingController nombreParkingController = TextEditingController(text: "");
  TextEditingController nombrePersonneMaxController = TextEditingController(text: "");
  TextEditingController prixController = TextEditingController(text: "");
  TextEditingController minimumReservationController = TextEditingController(text: "");
  TextEditingController reductionNombreReservationController = TextEditingController(text: "");
  TextEditingController reductionController = TextEditingController(text: "");
  int currentStep = 0;
  File? imagePrincipale;
  List<File> selectedImages = [];
  List<Widget> listPictures = [];
  List<Widget> listPicturesOfProperties = [];

  final picker = ImagePicker();

  bool meublee = false;
  String typePropriete = "appartement";
  String superficieUnite = "m²";
  String typePrix = "nuit";
  String pays = "Burkina Faso";
  String ville = "Ouagadougou";
  String latitude = "0.0";
  String longitude = "0.0";

  final _typePropriete = [
    "appartement",
    "hôtel",
    "résidence",
  ];

  final _superficieUnite = [
    "m²",
    "km²",
    "ha",
  ];

  final _pays = [
    "Burkina Faso",
  ];

  final _ville = [
    "Ouagadougou",
    "Bobo-Dioulasso",
  ];

  final _typePrix = [
    "nuit",
    "heure",
  ];

  @override
  void initState() {
    Property property = widget.property;
    nomController.text = property.nom!;
    quartierController.text = property.quartier!;
    descriptionController.text = property.description!;

    superficieController.text = property.superficie.toString();
    nombreChambreController.text = property.nombreChambre.toString();
    nombreBainController.text = property.nombreBain.toString();
    nombreParkingController.text = property.nombreParking.toString();
    nombrePersonneMaxController.text = property.nombrePersonneMax.toString();
    prixController.text = property.prix.toString();
    minimumReservationController.text = property.minimumReservation.toString();
    reductionNombreReservationController.text = property.reductionNombreReservation.toString();
    reductionController.text;

    typePropriete = property.typePropriete ?? "appartement";
    superficieUnite = property.superficieUnite ?? "m²";
    typePrix = property.typePrix ?? "nuit";
    pays = property.pays ?? "Burkina Faso";
    ville = property.ville ?? "Ouagadougou";
    latitude = property.latitude!;
    longitude = property.longitude!;

    if (property.pictures != null) {
      for (var e in property.pictures!) {
        listPicturesOfProperties.add(Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    '$mediaUrl${e.image}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await deletePropertyPicture(id: e.id.toString());
                setState(() => listPicturesOfProperties.removeAt(property.pictures!.indexOf(e)));
              },
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: const BoxDecoration(
                color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.remove, color: Colors.white, size: 13,),
              ),
            ),
          ],
        ));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepCancel: () => currentStep == 0
            ? null
            : setState(() {
                currentStep -= 1;
              }),
        onStepContinue: () {
          bool isLastStep = (currentStep == getSteps().length - 1);
          if (isLastStep) {
            saveProperty();
          } else {
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepTapped: (step) => setState(() {
          currentStep = step;
        }),
        steps: getSteps(),
      ),
    );
  }

  Future pickImagePrincipale() async {
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final tempImage = File(image.path);
      setState(() {
        imagePrincipale = tempImage;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick image $e");
      }
    }
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage();
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));

            listPictures.add(
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: kIsWeb
                              ? Image.network(
                                  selectedImages[i].path,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  selectedImages[i],
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      int index = i;
                      setState(() {
                        selectedImages.removeAt(index);
                        listPictures.removeAt(index);
                      });
                    },
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.remove, color: Colors.white, size: 13,),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Aucune photo seclectionnée')));
        }
      },
    );
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Description du post"),
        content: Column(
          children: [
            TextFormField(
              controller: nomController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Titre",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Champ requis';
                }
                return null;
              },
              onTap: () {},
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: const InputDecoration(),
                  isEmpty: ville == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: ville,
                      isDense: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          ville = newValue!;
                          state.didChange(newValue);
                        });
                      },
                      items: _ville.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: const InputDecoration(),
                  isEmpty: pays == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: pays,
                      isDense: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          pays = newValue!;
                          state.didChange(newValue);
                        });
                      },
                      items: _pays.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            TextFormField(
              controller: quartierController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Quartier",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Champ requis';
                }
                return null;
              },
              onTap: () {},
            ),
            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Champ requis';
                }
                return null;
              },
              onTap: () {},
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: prixController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Prix",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Champ requis';
                      }
                      return null;
                    },
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: const InputDecoration(),
                        isEmpty: typePrix == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: typePrix,
                            isDense: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                typePrix = newValue!;
                                state.didChange(newValue);
                              });
                            },
                            items: _typePrix.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: reductionNombreReservationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Min réduct.",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Champ requis';
                      }
                      return null;
                    },
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: reductionController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Réduction %",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Champ requis';
                      }
                      return null;
                    },
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Information de la propriété"),
        content: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Est meublée: ',
                  style: TextStyle(fontSize: 17.0),
                ),
                Checkbox(
                  checkColor: Colors.greenAccent,
                  activeColor: Colors.red,
                  value: meublee,
                  onChanged: (bool? value) {
                    setState(() {
                      meublee = value!;
                    });
                  },
                ),
              ],
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: const InputDecoration(),
                  isEmpty: typePropriete == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: typePropriete,
                      isDense: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          typePropriete = newValue!;
                          state.didChange(newValue);
                        });
                      },
                      items: _typePropriete.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: superficieController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Superficie",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Champ requis';
                      }
                      return null;
                    },
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: const InputDecoration(),
                        isEmpty: superficieUnite == '',
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: superficieUnite,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  typePropriete = newValue!;
                                  state.didChange(newValue);
                                });
                              },
                              items: _superficieUnite.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Informations pièces"),
        content: Column(
          children: [
            TextFormField(
              controller: nombreChambreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Nombre de chambre",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Champ requis';
                }
                return null;
              },
              onTap: () {},
            ),
            TextFormField(
              controller: nombreBainController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Nombre de douche",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Champ requis';
                }
                return null;
              },
              onTap: () {},
            ),
            TextFormField(
              controller: nombreParkingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Nombre de garages",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Champ requis';
                }
                return null;
              },
              onTap: () {},
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: const Text("Photos"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                pickImagePrincipale();
              },
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(
                      "$mediaUrl${widget.property.imagePrincipale}",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: imagePrincipale != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          imagePrincipale!,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.add,
                          size: 45,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              child: const Text("Ajouter d'autres photos"),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 5, left: 15),
              child: Row(children: [_addPicture(), ...listPicturesOfProperties, ...listPictures]),
            )
          ],
        ),
      ),
      Step(
        state: currentStep > 4 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 4,
        title: const Text("Position géographique"),
        content: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final LatLng? position = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChooseCoordonatesScreen()),
                );
                if (position != null) {
                  latitude = position.latitude.toString();
                  longitude = position.longitude.toString();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                child: const Text("Coordonées gps"),
              ),
            )
          ],
        ),
      ),
    ];
  }

  Widget _addPicture() => GestureDetector(
        onTap: () => getImages(),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(child: Icon(Icons.add)),
        ),
      );

  Future<void> deletePropertyPicture({required String id}) async {
    try {
      UiUtils.modalLoading(context, "Suppression en cours...");

      Map<String, String> queryParams = {};
      final Uri uri = Uri.parse("$propertiesPicturesUrl/$id").replace(queryParameters: queryParams);

      await delete(
        uri,
        headers: ApiUtils.getHeaders(),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
      //throw AlertException(errorMessageCode: e.toString());
    }
  }

  Future saveProperty() async {
    UiUtils.modalLoading(context, "Modification en cours...");
    var request = MultipartRequest(
      "POST",
      Uri.parse("$propertyUpdateUrl/${widget.property.id}"),
    )..headers.addAll(ApiUtils.getHeaders());

    request.fields["nom"] = nomController.text;
    request.fields["quartier"] = quartierController.text;
    request.fields["ville"] = ville;
    request.fields["pays"] = pays;
    request.fields["description"] = descriptionController.text;
    request.fields["type_propriete"] = typePropriete;
    request.fields["superficie"] = superficieController.text;
    request.fields["superficie_unite"] = superficieUnite;
    request.fields["nombre_chambre"] = nombreChambreController.text;
    request.fields["nombre_bain"] = nombreBainController.text;
    request.fields["nombre_parking"] = nombreParkingController.text;
    request.fields["nombre_personne_max"] = nombrePersonneMaxController.text;
    request.fields["meublee"] = meublee.toString();
    request.fields["prix"] = prixController.text;
    request.fields["type_prix"] = typePrix;
    request.fields["reduction_nombre_reservation"] = reductionNombreReservationController.text;
    request.fields["reduction"] = reductionController.text;
    request.fields["latitude"] = latitude;
    request.fields["longitude"] = longitude;

    if (imagePrincipale != null) {
      request.files.add(await MultipartFile.fromPath('image_principale', imagePrincipale!.path));
    }

    for (int i = 0; i < selectedImages.length; i++) {
      var file = await MultipartFile.fromPath('picture_$i', selectedImages[i].path);
      request.files.add(file);
    }
    request.fields["total_pictures"] = selectedImages.length.toString();

    final response = await request.send();

    if (!mounted) return;
    Navigator.of(context).pop();

    final responseBody = await response.stream.bytesToString();
    if (kDebugMode) {
      print(Uri.parse("$propertiesUrl/${widget.property.id}"));
      print('Code réponse du serveur : ${response.statusCode}');
      print('Réponse du serveur : $responseBody');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (!mounted) return;
      UiUtils.okAlertDialog(context, "Success", "Votre publication a été modifiée avec succès", () {
        Navigator.of(context).pop();
      });
    } else {
      if (!mounted) return;
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The loading indicator
                    const Icon(
                      Icons.error,
                      color: Colors.orange,
                      size: 96,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(space),
                      child: Text("Une erreur s'est produite"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Fermer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}
