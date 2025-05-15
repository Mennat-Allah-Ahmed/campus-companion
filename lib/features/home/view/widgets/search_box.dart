import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final List<String> _values = [
    'IEEE',
    'MSP',
    'ICPC',
    'Shoubra Engineering Students Union',
    'GDG',
    'SRT',
    'Table',
    'Profile',
  ];

  List<String> _filteredValues = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _filteredValues = _values;
  }

  void _filterValues(String query) {
    setState(() {
      _searchText = query;
      _filteredValues = _values
          .where((value) => value.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width * 0.88,
          height: size.height * 0.07,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Color(0xFF626262)),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: const Color(0xFF626262),
                size: size.width * 0.045,
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: Container(
                  height: size.height * 0.05,
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: _filterValues,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: const Color(0xFF626262),
                        fontSize: size.width * 0.04,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      isDense: true, // Minimize internal padding
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.01),
        if (_searchText.isNotEmpty)
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: size.width * 0.88,
              height: size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                itemCount: _filteredValues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredValues[index]),
                    onTap: () {
                      print('Selected: ${_filteredValues[index]}');
                      setState(() {
                        _searchText = _filteredValues[index];
                        _filteredValues = _values;
                      });
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
