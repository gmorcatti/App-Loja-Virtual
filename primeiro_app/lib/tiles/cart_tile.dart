import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primeiro_app/datas/cart_product.dart';
import 'package:primeiro_app/datas/product_data.dart';
import 'package:primeiro_app/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      CartModel.of(context).updatePrices();

      return Row(
        children: <Widget>[
          Container(
            width: 150.0,
            height: 170.0,
            child: Padding(
              padding: EdgeInsets.all(7.0),
              child: Image.network(
                cartProduct.productData.images[0],
                fit: BoxFit.cover,
            ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.productData.title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19.0),
                  ),
                  SizedBox(height: 4.0,),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                  ),
                  SizedBox(height: 1.0,),
                  Text(
                    "R\$ ${(cartProduct.productData.price * cartProduct.quantity).toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: cartProduct.quantity > 1 ? (){
                          CartModel.of(context).decProduct(cartProduct);
                        } : null,
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CartModel.of(context).incProduct(cartProduct);
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection('products').document(cartProduct.category)
            .collection('items').document(cartProduct.pid).get(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              return _buildContent();
            } else {
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
        )
      :
        _buildContent()
    );
  }
}