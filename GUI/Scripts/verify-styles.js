// Script to verify CSS loading and application
window.onload = function() {
    console.log('Verifying styles...');
    
    // Check if stylesheets are loaded
    var styles = document.styleSheets;
    console.log('Found ' + styles.length + ' stylesheets');
    
    for(var i = 0; i < styles.length; i++) {
        try {
            console.log('Stylesheet ' + i + ':', styles[i].href);
        } catch(e) {
            console.log('Error checking stylesheet ' + i + ':', e);
        }
    }

    // Verify CSS variables through computed style
    var root = getComputedStyle(document.documentElement);
    var primary = root.getPropertyValue('--primary-color') || 'not set';
    var secondary = root.getPropertyValue('--secondary-color') || 'not set';
    
    console.log('Primary color:', primary);
    console.log('Secondary color:', secondary);

    // Check specific elements
    var elements = {
        'Login card': '.login-card',
        'Form controls': '.form-control',
        'Buttons': '.btn',
        'Features': '.feature-card'
    };

    for(var element in elements) {
        var found = document.querySelector(elements[element]);
        console.log(element + ':', found ? 'Found' : 'Missing');
        
        if(found) {
            var styles = getComputedStyle(found);
            console.log('- Background:', styles.backgroundColor);
            console.log('- Border radius:', styles.borderRadius);
            console.log('- Box shadow:', styles.boxShadow);
        }
    }

    // Create debug info panel
    var debugPanel = document.createElement('div');
    debugPanel.id = 'styleDebug';
    debugPanel.style.cssText = [
        'position: fixed',
        'bottom: 20px',
        'right: 20px',
        'padding: 10px',
        'background: rgba(0,0,0,0.8)',
        'color: white',
        'border-radius: 5px',
        'font-size: 12px',
        'z-index: 9999'
    ].join(';');

    // Add debug info
    var debugInfo = [
        'Styles loaded: ' + styles.length,
        'Primary color: ' + primary,
        'Secondary color: ' + secondary
    ].join('<br>');

    debugPanel.innerHTML = debugInfo;
    
    // Only show in development
    if(window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        document.body.appendChild(debugPanel);
        setTimeout(function() {
            if(debugPanel && debugPanel.parentNode) {
                debugPanel.parentNode.removeChild(debugPanel);
            }
        }, 5000);
    }

    // Check for critical style issues
    var criticalStyles = {
        '.login-card': ['background-color', 'border-radius', 'box-shadow'],
        '.btn-primary': ['background-color', 'color', 'border-radius'],
        '.form-control': ['border', 'padding', 'border-radius']
    };

    for(var selector in criticalStyles) {
        var element = document.querySelector(selector);
        if(element) {
            var computed = getComputedStyle(element);
            criticalStyles[selector].forEach(function(prop) {
                if(!computed[prop] || computed[prop] === 'none') {
                    console.warn('Missing critical style:', selector, prop);
                }
            });
        } else {
            console.warn('Critical element not found:', selector);
        }
    }
};