#!/usr/bin/env python3.8

import json


class ChangeLogBuilder(object):

    def __init__(self):
        self.json_file = "changelog.json"
        self.target_file = "CHANGELOG.md"
        self.products_by_name = {}

    def generate(self):
        with open(self.json_file, "r") as file:
            json_object = json.load(file)

        self.load_products(json_object['products'])
        md_file = open(self.target_file, "w")
        md_file.write(f'# {json_object["title"]}\n\n')
        md_file.write(f'{json_object["description"]}\n\n')
        for log_item in json_object['log']:
            version = log_item['version'] if 'version' in log_item else None
            date = log_item['date']
            product_name = log_item['product']
            line = ''
            if version:
                line = f'[{version}] - {date}'
            else:
                line = f'{date}'

            if product_name in self.products_by_name:
                product = self.products_by_name[product_name]
                line = f'{line} - [{product_name}]({product.url})'

            md_file.write(f'## {line}\n')

            added = []
            changed = []
            removed = []
            other = []
            for change in log_item['changes']:
                change_type = change["type"]

                if change_type == "Added":
                    added.append(change)
                elif change_type == "Changed":
                    changed.append(change)
                elif change_type == "Removed":
                    removed.append(change)
                else:
                    other.append(change)

            self.write_change_list("Added", md_file, added)
            self.write_change_list("Changed", md_file, changed)
            self.write_change_list("Removed", md_file, removed)
            self.write_change_list("Other", md_file, other)

        md_file.close()

    def write_change_list(self, change_type, md_file, change_list):
        if len(change_list) == 0:
            return
        md_file.write('\n')
        md_file.write(f'## {change_type}\n')
        for change in change_list:
            md_file.write(f'- {change["title"]}\n')
            md_file.write(f'    > {change["description"]}\n')

        md_file.write('\n')

    def load_products(self, products_json):
        for product_json in products_json:
            name = product_json['name']
            url = product_json['url']
            self.products_by_name[name] = Product(name, url)

class Product(object):

    def __init__(self, name, url):
        self.name = name
        self.url = url

if __name__ == "__main__":
    builder = ChangeLogBuilder()
    builder.generate()

