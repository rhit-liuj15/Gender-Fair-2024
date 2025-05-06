class SchoolData {
	/// The data class that stored data specific to the school with [uid] and [name].

  late Map<String, dynamic> _data;
	int uid = -4826;
	late String name;
	bool get isInvalid {
		return _data.isEmpty;
	}

  SchoolData.fromJSON(dynamic json) {
    _data = json;
		uid = getUID();
		name = getName();
  }

  SchoolData.unknownUID(int uid) {
		uid = uid;
		name = "Unknown School $uid!";
    _data = {};
  }

  @override
  String toString() {
    return "\n${getName()}}\nUID ${getUID()}\nData: $_data";
  }

  String getName() {
    return getString("INSTNM");
  }

  int getUID() {
    return getInt("UNITID", convert: false);
  }

  int getInt(String name, {bool convert = true}) {
		if (_data.containsKey(name)) {
			if (_data[name] == null) {
				throw Exception("The SchoolData for UID ${_data["UNITID"]} has attribute \"$name\", but the value is null (expected: int)");
			} else if ((_data[name] is! int) & !convert) {
				throw Exception("The SchoolData for UID ${_data["UNITID"]} has attribute \"$name\", but the type is ${_data[name].runtimeType} (expected: int)\nActual data: ${_data[name]}");
			} else if (_data[name] is int) {
				return _data[name];
			} else {
				int? parseResult = int.tryParse(_data[name]);
				if (parseResult == null) {
					throw Exception("Parsing \"${_data[name]}\" as int failed.");
				} else {
					return parseResult;
				}
			}
		} else {
			throw Exception("The SchoolData for UID ${_data["UNITID"]} does not have attribute \"$name\"");
		}
  }

  num getNum(String name, {bool convert = true}) {
		if (_data.containsKey(name)) {
			if (_data[name] == null) {
				throw Exception("The SchoolData for UID ${_data["UNITID"]} has attribute \"$name\", but the value is null (expected: num)");
			} else if ((_data[name] is! num) & !convert) {
				throw Exception("The SchoolData for UID ${_data["UNITID"]} has attribute \"$name\", but the type is ${_data[name].runtimeType} (expected: num)\nActual data: ${_data[name]}");
			} else if (_data[name] is num) {
				return _data[name];
			} else {
				num? parseResult = num.tryParse(_data[name]);
				if (parseResult == null) {
					throw Exception("Parsing \"${_data[name]}\" as num failed.");
				} else {
					return parseResult;
				}
			}
		} else {
			throw Exception("The SchoolData for UID ${_data["UNITID"]} does not have attribute \"$name\"");
		}
  }

  String getString(String name, {bool convert = true}) {
		if (_data.containsKey(name)) {
			if (_data[name] == null) {
				throw Exception("The SchoolData for UID ${_data["UNITID"]} has attribute \"$name\", but the value is null (expected: String)");
			}
			if ((_data[name] is! String) & !convert) {
				throw Exception("The SchoolData for UID ${_data["UNITID"]} has attribute \"$name\", but the type is ${_data[name].runtimeType} (expected: String)");
			}
			return _data[name].toString();
		} else {
			throw Exception("The SchoolData for UID ${_data["UNITID"]} does not have attribute \"$name\"");
		}
  }
}
