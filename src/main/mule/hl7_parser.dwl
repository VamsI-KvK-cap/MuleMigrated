%dw 2.0
output application/json

fun parse_hl7_message(str_message) {
    var segments = str_message splitBy '\r'
    var parsed_message = {}

    var segment_mapping = {
        'MSA': 'MSA_struct',
        'ERR': 'ERR_struct',
        'ACK': 'ACK_struct',
        'MSH': 'MSH_struct'
    }

    for (segment in segments) {
        var segment_parts = segment splitBy '|'
        var segment_id = segment_parts[0]
        var segment_structure = segment_mapping[segment_id]

        var segment_object = {}

        if (segment_structure == 'MSA_struct') {
            segment_object['segment_ID'] = segment_parts[0]
            segment_object['MSA-1-acknowledgment_code'] = segment_parts[1]
            segment_object['MSA-2-message_control_ID'] = segment_parts[2]
            segment_object['MSA-3-text_message'] = segment_parts[3]
            segment_object['MSA-4-expected_sequence_number'] = segment_parts[4]
            segment_object['MSA-5-delayed_acknowledgment_type'] = segment_parts[5]
            segment_object['MSA-6-error_condition'] = parse_ce(segment_parts[6])
        } else if (segment_structure == 'ERR_struct') {
            segment_object['segment_ID'] = segment_parts[0]
            segment_object['ERR-1-error_code'] = segment_parts[1]
            segment_object['ERR-2-severity'] = segment_parts[2]
            segment_object['ERR-3-error_text'] = segment_parts[3]
            segment_object['ERR-4-application_error_code'] = parse_ce(segment_parts[4])
        } else if (segment_structure == 'ACK_struct') {
            segment_object['segment_ID'] = segment_parts[0]
            segment_object['ACK-1-acknowledgment_code'] = segment_parts[1]
            segment_object['ACK-2-message_control_ID'] = segment_parts[2]
            segment_object['ACK-3-text_message'] = segment_parts[3]
        } else if (segment_structure == 'MSH_struct') {
            segment_object['segment_ID'] = segment_parts[0]
            segment_object['MSH-1-field_separator'] = segment_parts[1]
            segment_object['MSH-2-encoding_characters'] = segment_parts[2]
            segment_object['MSH-3-sending_application'] = segment_parts[3]
            segment_object['MSH-4-sending_facility'] = segment_parts[4]
            segment_object['MSH-5-receiving_application'] = segment_parts[5]
            segment_object['MSH-6-receiving_facility'] = segment_parts[6]
            segment_object['MSH-7-date_time_of_message'] = segment_parts[7]
            segment_object['MSH-8-security'] = segment_parts[8]
            segment_object['MSH-9-message_type'] = segment_parts[9]
            segment_object['MSH-10-message_control_ID'] = segment_parts[10]
            segment_object['MSH-11-processing_id'] = segment_parts[11]
            segment_object['MSH-12-version_ID'] = segment_parts[12]
        }

        parsed_message[segment_id] = (parsed_message[segment_id] ++ segment_object)
    }

    return parsed_message
}

fun parse_ce(ce_string) {
    var ce_parts = ce_string splitBy '^'
    return {
        'ID_code': ce_parts[0],
        'text': ce_parts[1],
        'coding_scheme': ce_parts[2],
        'alternate_ID': ce_parts[3],
        'alternate_text': ce_parts[4],
        'alternate_coding_scheme': ce_parts[5]
    }
}