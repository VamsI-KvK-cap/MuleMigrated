package dw;

output application/json

fun process_ack_message(message_string: String): String {
  var input_map = {}
  var output_map = {}
  var skip = false
  try {
    input_map = parse_hl7_message(message_string)
    output_map = {}
    if (input_map contains 'MSA' and sizeOf(input_map['MSA']) > 0) {
      var msa_segment = input_map['MSA'][0]
      if (msa_segment['MSA-3-text_message'] contains 'ZZZ') {
        skip = true
      }
    } else {
      skip = false
    }
    if (!skip) {
      output_map['MSH'] = input_map['MSH']
      output_map['MSA'] = input_map['MSA']
    }
    var output_string = write(output_map, 'application/json')
    return skip ? '' : output_string
  } catch (e) {
    return ''
  }
}