package dw;

output application/json

fun AI_PoC_Simple_Filter(message_string) {
  var input_map = {}
  var output_map = {}
  try {
    input_map = parse_hl7_message(message_string)
    output_map = {}
    var skip = false
    if (input_map['MSA'] != null) {
      var msa_segment = input_map['MSA'][0]
      var msa_text_message = msa_segment['MSA-3-text_message']
      if (msa_text_message contains 'ZZZ') {
        skip = true
      }
    }
    if (!skip) {
      output_map['MSH'] = input_map['MSH']
      output_map['MSA'] = input_map['MSA']
    }
    return output_map as String
  } catch (error) {
    return ''
  } finally {
    input_map = {}
    output_map = {}
  }
}