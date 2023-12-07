import 'package:flutter/material.dart';
import 'package:realestatebf/models/filter.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  RangeValues _rangeSliderValue = const RangeValues(0.0, 80000);
  TextEditingController nombreChambreController = TextEditingController(text: "");
  TextEditingController nombreParkingController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            "Filtre",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: nombreChambreController,
            keyboardType: TextInputType.number,
            showCursor: true,
            decoration: const InputDecoration(
              hintText: "Nombre de chambres",
              //prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: nombreParkingController,
            keyboardType: TextInputType.number,
            showCursor: true,
            decoration: const InputDecoration(
              hintText: "Nombre de garages",
              //prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 15),
          Text(
              "Prix : ${_rangeSliderValue.start.toStringAsFixed(0)} - ${_rangeSliderValue.end.toStringAsFixed(0)}"),
          RangeSlider(
            min: 0.0,
            max: 900000.0,
            divisions: 10000,
            labels: RangeLabels(
              _rangeSliderValue.start.round().toString(),
              _rangeSliderValue.end.round().toString(),
            ),
            values: _rangeSliderValue,
            onChanged: (RangeValues values) {
              setState(() {
                _rangeSliderValue = values;
              });
            },
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () async {
              Filter filter = Filter(
                chambre: nombreChambreController.text,
                garage: nombreParkingController.text,
                prixMin: _rangeSliderValue.start.round().toString(),
                prixMax: _rangeSliderValue.end.round().toString(),
              );
              Navigator.pop(context, filter);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              child: const Center(
                child: Text(
                  "Valider",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
