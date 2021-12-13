import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/orders.dart';
import '../screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                  id: cart.items.values.toList()[i].id,
                  productId: cart.items.keys.toList()[i],
                  title: cart.items.values.toList()[i].title,
                  quantity: cart.items.values.toList()[i].quantity,
                  price: cart.items.values.toList()[i].price),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              print(widget.cart.items.values.toList()[0].title);
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );
                widget.cart.clear();
                Navigator.of(context)
                    .pushReplacementNamed(ProductsOverviewScreen.routeName);
                setState(() {
                  _isLoading = false;
                });
              } catch (e) {
                setState(() {
                  _isLoading = false;
                  print('cart screen' + e);
                });
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                      title: Text('An error occured!'),
                      content: Text('Something went wrong'),
                      actions: [
                        FlatButton(
                          child: Text('Okay'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ]),
                );
              }
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
