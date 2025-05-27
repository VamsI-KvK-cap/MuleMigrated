package ai.poc.simple.filter

%dw 2.0
output application/json
fun process_hl7_ack(message_string: String): String {
  var input_map = {}
  var output_map = {}
  try {
    input_map = parse_hl7_message(message_string)
    output_map = {}
    var skip = false
    if (input_map containsKey 'MSA') {
      var msa_message = input_map['MSA'][0]['MSA-3-text_message']
      if (msa_message contains 'ZZZ') {
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