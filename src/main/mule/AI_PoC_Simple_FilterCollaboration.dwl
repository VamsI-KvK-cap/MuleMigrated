package src.main.mule;

%dw 2.0
output application/json
fun AI_PoC_Simple_Filter(message_string: String): String {
  var input_map = {};
  var output_map = {};
  try {
    input_map = parse_hl7_message(message_string);
    output_map = {};
    var skip = false;
    if (input_map contains 'MSA') {
      var msa_segment = input_map['MSA'][0];
      var msa_text_message = msa_segment['MSA-3-text_message'];
      if (msa_text_message contains 'ZZZ') {
        skip = true;
      }
    }
    if (skip) {
      output_map = {};
    } else {
      output_map['MSH'] = input_map['MSH'];
      output_map['MSA'] = input_map['MSA'];
    }
    var processed_message = convert_to_string(output_map);
    input_map = {};
    output_map = {};
    return processed_message;
  } catch (e) {
    return "";
  }
}