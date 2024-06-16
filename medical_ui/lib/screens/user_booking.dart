// user_booking.dart
import 'package:flutter/material.dart';

class UserBookingPage extends StatelessWidget {
  const UserBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount:
            10, // Example: number of bookings, you can replace with your dynamic data
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              leading: Icon(Icons.event),
              title: Text('Booking ${index + 1}'),
              subtitle: Text('Details about booking ${index + 1}'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Define what happens when a booking is tapped
              },
            ),
          );
        },
      ),
    );
  }
}
