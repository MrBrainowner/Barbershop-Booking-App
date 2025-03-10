import 'package:barbermate_customers/data/models/booking_model/booking_model.dart';
import 'package:barbermate_customers/features/customer/views/widgets/dashboard/appointment_card.dart';
import 'package:flutter/material.dart';

Widget buildAppointmentWidget(BookingModel booking) {
  switch (booking.status) {
    case 'pending':
      return AppointmentCardCustomers(booking: booking);
    case 'confirmed':
      return AppointmentConfirmedCardCustomers(booking: booking);
    case 'canceled':
      return AppointmentDoneCardCustomers(booking: booking);
    case 'declined':
      return AppointmentDoneCardCustomers(booking: booking);
    case 'done':
      return AppointmentDoneCardCustomers(booking: booking);
    default:
      return AppointmentCardCustomers(booking: booking);
  }
}
