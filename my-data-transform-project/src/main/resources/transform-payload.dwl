%dw 2.0
output application/json
---
{
    customerName: payload.customer.name,
    customerEmail: payload.customer.email,
    customerAddress: payload.customer.address
}
