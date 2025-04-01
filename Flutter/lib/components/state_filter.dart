import 'package:flutter/material.dart';

class StateFilter extends StatefulWidget {
  final Function(List<Map<String, String>>) onSelectState;
  // final Function(List<Map<String, String>>) onRemoveState;

  const StateFilter({
    required this.onSelectState,
    // required this.onRemoveState,
    super.key,
  });

  @override
  _StateFilterState createState() => _StateFilterState();
}

class _StateFilterState extends State<StateFilter> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> states = [
    {'name': 'Alabama', 'abbr': 'AL'},
    {'name': 'Alaska', 'abbr': 'AK'},
    {'name': 'Arizona', 'abbr': 'AZ'},
    {'name': 'Arkansas', 'abbr': 'AR'},
    {'name': 'California', 'abbr': 'CA'},
    {'name': 'Colorado', 'abbr': 'CO'},
    {'name': 'Connecticut', 'abbr': 'CT'},
    {'name': 'Delaware', 'abbr': 'DE'},
    {'name': 'Florida', 'abbr': 'FL'},
    {'name': 'Georgia', 'abbr': 'GA'},
    {'name': 'Hawaii', 'abbr': 'HI'},
    {'name': 'Idaho', 'abbr': 'ID'},
    {'name': 'Illinois', 'abbr': 'IL'},
    {'name': 'Indiana', 'abbr': 'IN'},
    {'name': 'Iowa', 'abbr': 'IA'},
    {'name': 'Kansas', 'abbr': 'KS'},
    {'name': 'Kentucky', 'abbr': 'KY'},
    {'name': 'Louisiana', 'abbr': 'LA'},
    {'name': 'Maine', 'abbr': 'ME'},
    {'name': 'Maryland', 'abbr': 'MD'},
    {'name': 'Massachusetts', 'abbr': 'MA'},
    {'name': 'Michigan', 'abbr': 'MI'},
    {'name': 'Minnesota', 'abbr': 'MN'},
    {'name': 'Mississippi', 'abbr': 'MS'},
    {'name': 'Missouri', 'abbr': 'MO'},
    {'name': 'Montana', 'abbr': 'MT'},
    {'name': 'Nebraska', 'abbr': 'NE'},
    {'name': 'Nevada', 'abbr': 'NV'},
    {'name': 'New Hampshire', 'abbr': 'NH'},
    {'name': 'New Jersey', 'abbr': 'NJ'},
    {'name': 'New Mexico', 'abbr': 'NM'},
    {'name': 'New York', 'abbr': 'NY'},
    {'name': 'North Carolina', 'abbr': 'NC'},
    {'name': 'North Dakota', 'abbr': 'ND'},
    {'name': 'Ohio', 'abbr': 'OH'},
    {'name': 'Oklahoma', 'abbr': 'OK'},
    {'name': 'Oregon', 'abbr': 'OR'},
    {'name': 'Pennsylvania', 'abbr': 'PA'},
    {'name': 'Rhode Island', 'abbr': 'RI'},
    {'name': 'South Carolina', 'abbr': 'SC'},
    {'name': 'South Dakota', 'abbr': 'SD'},
    {'name': 'Tennessee', 'abbr': 'TN'},
    {'name': 'Texas', 'abbr': 'TX'},
    {'name': 'Utah', 'abbr': 'UT'},
    {'name': 'Vermont', 'abbr': 'VT'},
    {'name': 'Virginia', 'abbr': 'VA'},
    {'name': 'Washington', 'abbr': 'WA'},
    {'name': 'West Virginia', 'abbr': 'WV'},
    {'name': 'Wisconsin', 'abbr': 'WI'},
    {'name': 'Wyoming', 'abbr': 'WY'},
  ];
  
  List<Map<String, String>> filteredStates = [];
  List<Map<String, String>> selectedStates = [];

  void _filterStates(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStates = [];
      } else {
        filteredStates = states
            .where((state) => state['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectState(Map<String, String> state) {
    setState(() {
      if (!selectedStates.contains(state)) {
        selectedStates.add(state);
        widget.onSelectState(selectedStates);
      }
      controller.clear();
      filteredStates = [];
    });
  }

  void _removeState(Map<String, String> state) {
    setState(() {
      selectedStates.remove(state);
      widget.onSelectState(selectedStates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Filter By State',
            hintText: 'Enter State Name Here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.filter_alt_sharp),
          ),
          onChanged: _filterStates,
        ),
        const SizedBox(height: 10),
        if (filteredStates.isNotEmpty)
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListView.builder(
              itemCount: filteredStates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${filteredStates[index]['name']!}, ${filteredStates[index]['abbr']!}"),
                  onTap: () {
                    // widget.onSelectState(filteredStates[index]);
                    _selectState(filteredStates[index]);
                    controller.clear();
                    setState(() => filteredStates = []);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: selectedStates.map((state) {
              return ElevatedButton(
                onPressed: () {
                  _removeState(state);
                }, 
                child: Text('Remove ${state['abbr']!}'),
              );
            }).toList(),
          ),
      ],
    );
  }
}
