# __Checkout__

__checkout__ is a sample Ruby application used to manage products and promotions. Works with ruby 2.3.1

## __Usage__

* run `bundle install`
* run IRB with `rake console`

Create some inventory:  

```
heart = Product.new('001', 'Lavender heart', '9.25')  
cufflinks = Product.new('002', 'Personalized cufflinks', '45')
shirt = Product.new('003', 'Kids T-shirt', '19.95')
```

Next, make a new promotion! Promotions can take an options hash with these keys: `discount`, `min_quantity`, `min_value`, `product_code`, and `percent`

Here is an example of a promo that takes 10% off your purchase when you spend over £60:

```
promotion = Promo.new({ discount: 0.1, min_value: 65, percent: true })
```

Time to shop! Create a new basket with our promotion:  

```
basket = Checkout.new(promotion)
```

Add some items to the basket:

```
basket.scan(heart)
basket.scan(cufflinks)  
basket.scan(shirt)
```

Check your total price:  

`basket.total` # *Total price: £66.78*


## Tests
All tests are currently passing. Run `bundle exec rspec` to test.

## Questions
`me@sofiachen.com`
