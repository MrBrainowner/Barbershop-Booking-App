import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/features/barbershop/views/widgets/appoiments/appoiments_widget.dart';
import 'package:flutter/material.dart';

Widget buildAppointmentWidget(BookingModel booking) {
  switch (booking.status) {
    case 'pending':
      return AppointmentCard(
        booking: booking,
      );
    case 'confirmed':
      return AppointmentConfirmedCard(
        booking: booking,
      );
    case 'canceled':
      return AppointmentDoneCard(
        booking: booking,
      );
    case 'declined':
      return AppointmentDoneCard(
        booking: booking,
      );
    case 'done':
      return AppointmentDoneCard(
        booking: booking,
      );
    default:
      return AppointmentDoneCard(booking: booking);
  }
}
