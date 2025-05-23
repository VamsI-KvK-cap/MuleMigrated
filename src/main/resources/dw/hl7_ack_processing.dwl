package dw.hl7;

%dw 2.0
output application/json

fun parse_hl7_message(message_string) =
    // Implementation for parsing HL7 message into a map
    // ...

fun convert_map_to_string(map) =
    // Implementation for converting a map to string format
    // ...

fun process_ack_message(message_string: String): String =
    var input_map = parse_hl7_message(message_string);
    var output_map = {};
    var skip = false;
    if (input_map['MSA']) {
        var msa_message = input_map['MSA'][0]['MSA-3-text_message'];
        if (msa_message contains 'ZZZ') {
            skip = true;
        }
    }
    if (skip) {
        output_map = {};
    } else {
        output_map['MSH'] = input_map['MSH'];
        output_map['MSA'] = input_map['MSA'];
    }
    var output_string = convert_map_to_string(output_map);
    input_map = {};
    output_map = {};
    output_string;