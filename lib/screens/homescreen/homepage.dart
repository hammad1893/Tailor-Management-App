import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/screens/homescreen/add_customer_screen.dart';
import 'package:tailor_app/screens/homescreen/specific_customer_detail.dart';
import 'package:tailor_app/state/customer_state.dart';
import 'package:tailor_app/utils/colors.dart';
import 'package:tailor_app/utils/text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isearching = false;
  TextEditingController searchCtrl = TextEditingController();

  List filteredcustomers(List customers, String query) {
    if (query.isEmpty) {
      return customers;
    } else {
      return customers
          .where(
            (customer) =>
                customer.clientName.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                customer.clothType.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                customer.orderStatus.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerState>(context, listen: false).fetchCustomers();
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Appcolors.backgroundcolor,
        title: isearching
            ? TextField(
                controller: searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search customers...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : Text(
                'Tailor Book',
                style: Apptext.headingtext.copyWith(fontSize: 24),
              ),
        actions: [
          if (isearching)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.black),
              onPressed: () {
                setState(() {
                  isearching = false;
                  searchCtrl.clear();
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  isearching = true;
                });
              },
            ),
        ],
      ),
      body: Consumer<CustomerState>(
        builder: (context, customerState, child) {
          if (customerState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredCustomers = isearching
              ? filteredcustomers(customerState.customers, searchCtrl.text)
              : customerState.customers;

          if (customerState.customers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No customers yet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Appcolors.headingColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add a customer to get started",
                    style: Apptext.bodytext.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          if (filteredCustomers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text("No results found", style: Apptext.headingtext),
                  const SizedBox(height: 8),
                  Text(
                    "Try searching with different keywords",
                    style: Apptext.bodytext.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: filteredCustomers.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final Customers = filteredCustomers[index];
              return _CustomerCard(
                customerName: Customers.clientName,
                clothType: Customers.clothType,
                status: Customers.orderStatus,
                deliveryDate: Customers.deliveryDate ?? "N/A",
                imagePath: Customers.customerPhotoUrl ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CustomerDetailScreen(customer: Customers),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _CustomerCard({
    required String customerName,
    required String clothType,
    required String status,
    required String deliveryDate,
    required String imagePath,
    VoidCallback? onTap,
  }) {
    Size size = MediaQuery.of(context).size;

    Color statusColor = Colors.blue;
    if (status.toLowerCase() == 'pending') {
      statusColor = Colors.orange;
    } else if (status.toLowerCase() == 'in_progress') {
      statusColor = Colors.blue;
    } else if (status.toLowerCase() == 'completed') {
      statusColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imagePath.isNotEmpty
                ? Image.network(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.person, color: Colors.grey),
                  ),
          ),
          SizedBox(width: size.width * .02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customerName, style: Apptext.subheading),
                SizedBox(height: size.height * .01),
                Text(clothType, style: Apptext.bodytext),
                SizedBox(height: size.height * .01),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: size.width * .02),
                    Text(status, style: Apptext.bodytext),
                  ],
                ),
                SizedBox(height: size.height * .01),
                Text('Due on $deliveryDate', style: Apptext.bodytext),
              ],
            ),
          ),
          SizedBox(width: size.width * .02),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[50],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'View',
              style: TextStyle(
                color: Appcolors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
