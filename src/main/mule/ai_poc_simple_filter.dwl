%dw 2.0
output application/json
fun process_hl7_ack(message_string: String): String {
    var input_map = {}
    var output_map = {}
    var skip = false
    try {
        input_map = parse_hl7_message(message_string)
        output_map = {}
        if (input_map['MSA'] != null and sizeOf(input_map['MSA']) > 0) {
            var msa_segment = input_map['MSA'][0]
            var msa_text_message = msa_segment['MSA-3-text_message']
            if (msa_text_message contains 'ZZZ') {
                skip = true
            }
        }
        if (!skip) {
            output_map['MSH'] = input_map['MSH'][0]
            output_map['MSA'] = input_map['MSA'][0]
            return output_map as String
        }
        return ''
    } catch (error) {
        return ''
    } finally {
        input_map = {}
        output_map = {}
    }
}