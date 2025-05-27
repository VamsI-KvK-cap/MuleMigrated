package hl7.filter

%dw 2.0
import * from dw::core::Strings
output application/json

fun parse_hl7_message(str_message: String): Object =
    // Implement HL7 message parsing logic here
    // This is a placeholder for the actual parsing logic
    // The actual implementation should convert the HL7 message into a structured object

var input_map = {}
var output_map = {}
var skip = false
input_map = parse_hl7_message(message_string)
output_map = {}
if (input_map contains 'MSA') {
    var msa_segment = input_map['MSA'][0]
    var msa_text_message = msa_segment['MSA-3-text_message']
    skip = msa_text_message contains 'ZZZ'
} else {
    skip = false
}
if (!skip) {
    output_map['MSH'] = input_map['MSH']
    output_map['MSA'] = input_map['MSA']
}
var output_string = write(output_map, 'application/json')
input_map = {}
output_map = {}
return skip ? '' : output_string