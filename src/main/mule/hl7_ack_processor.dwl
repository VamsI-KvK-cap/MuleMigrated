package hl7

%dw 2.0
output application/hl7
fun process_ack_message(message_string: String): String {
  var input_map = {}
  var output_map = {}
  try {
    input_map = parse_hl7_message(message_string)
    output_map = {}
    var skip = false
    if (input_map.MSA) {
      if (input_map.MSA.size() > 1) {
        // Log multiple MSA segments
      }
      var msa_text_message = input_map.MSA[0].MSA-3-text_message
      if (msa_text_message contains 'ZZZ') {
        skip = true
      }
    } else {
      // Log no MSA segments found
    }
    if (!skip) {
      output_map.MSH = input_map.MSH
      output_map.MSA = input_map.MSA
    }
    var output_string = write(output_map, 'application/hl7')
    input_map = {}
    output_map = {}
    return output_string
  } catch (error) {
    return ''
  }
}