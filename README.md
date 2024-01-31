
# Cash Register Application

This application scans products from the command line and adds them to a receipt.

## How to run the application

- `ruby main.rb`

## How to run the tests

- `rspec`

## Structure

- `data`
  - contains the `products.yml` file where there are details about all the products
    and all the rules that should apply to them


- `resources`
  - contains the `product` and the `receipt` resources
  - `product` resource is used to store the details of a product from the `yml` file
    and apply the rules for the products
  - `receipt` resource is used to keep all the products that were scanned and the prices


- `rules`
  - contains all the rules that can apply to the products
  - `rule` class is just an abstract one
  - all the other classes will extend the `rule` class and will implement the `apply` method

- `services`
  - `cash_register` - creates a receipt and add the scanned products to it
  - `scanner` - used to scan the products and stop when there is no more

## Flexibility

If the managers want to add new products, the only file that should be modified is
`products.yml`.

If the managers want to add or remove rules for the products, they should do it by
updating the rules for the products in `products.yml`.

The only ruby files that should be updated are the concrete rule classes from the `rule`
folder. Th rules should be added by the convention: 
- for each new rule `new_rule` that is added in the yml configuration, a new
class `NewRule` should be implemented.