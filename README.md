![](Logo/header.png)
# JRCountDown
A great of the countdown widget, it is very convenient and easy to use.


How To Use
----------

### Using NSObject+JRCountDown category with Block style.

Just #import the NSObject+JRCountDown.h header, and call the jr_configureWithToFutureDate:intervaltTime:whileExecutingBlock:completionBlock:
method, configure the while executing block and completion block. Everything will be
handled for you.

```objective-c
#import <NSObject+JRCountDown.h>

...

- (IBAction)buttonClick:(UIButton *)sender {
    [[sender jr_configureWithCountDownTime:5.f intervalTime:1.f whileExecutingBlock:^(NSObject* selfInstance, CGFloat SurplusSec) {

        //do somethings, such as show the countdown on the button.

    } completionBlock:^(NSObject* selfInstance){
        
    	//you can set the sender state on this

    }] jr_start]; //method return the instance, you can call jr_start nethod to start at the same time.
}
```

### Using NSObject+JRCountDown category with future time style.

you can uses the future date to the parameters, if more than present time, the jr_start method will not be executed.

```objective-c
#import <NSObject+JRCountDown.h>

...

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [[cell.textLabel jr_configureWithToFutureDate:self.dateArray[indexPath.row] intervaltTime:0.1f whileExecutingBlock:^(NSObject* selfInstance, CGFloat SurplusSec) {
        ((UILabel *)selfInstance).text = [NSString stringWithFormat:@"future time countdown %f second", SurplusSec];
    } completionBlock:^(NSObject* selfInstance){
        ((UILabel *)selfInstance).text = @"completion";
    }] jr_start];
    
    return cell;
}
```

### Installation by cloning the repository

In order to gain access to all the files from the repository, you should clone it.
```
git clone --recursive https://github.com/JerryLoveRice/JRCountDown.git
```

Future Enhancements
-------------------

- I think I'm gradually improving, and hope that put forward suggestions.

## Licenses

All source code is licensed under the [MIT License](https://raw.githubusercontent.com/JerryLoveRice/JRCountDown/master/LICENSE).
