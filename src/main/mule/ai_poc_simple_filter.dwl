package ai.poc.simple.filter

%dw 2.0
output application/json
import * from dw::core::Strings

fun parse_hl7_message(message_string: String): Object {
    // Implementation of HL7 message parsing
}

fun process_hl7_ack(message_string: String): String {
    var input_map = {};
    var output_map = {};
    try {
        input_map = parse_hl7_message(message_string);
        output_map = {};
        var skip = false;

        if (input_map contains 'MSA' and sizeOf(input_map['MSA']) > 0) {
            var msa_message = input_map['MSA'][0]['MSA-3-text_message'];
            if (msa_message contains 'ZZZ') {
                skip = true;
            } else {
                skip = false;
            }
        } else {
            skip = false;
        }

        if (skip) {
            output_map = {};
        } else {
            output_map['MSH'] = input_map['MSH'];
            output_map['MSA'] = input_map['MSA'];
        }

        var processed_message = write(output_map, "application/json");
        input_map = {};
        output_map = {};
        return processed_message;
    } catch (e) {
        return "";
    }
}