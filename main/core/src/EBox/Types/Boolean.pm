# Copyright (C) 2007 Warp Networks S.L.
# Copyright (C) 2008-2013 Zentyal S.L.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

use strict;
use warnings;

package EBox::Types::Boolean;

use base 'EBox::Types::Basic';

# Group: Public methods

sub new
{
    my $class = shift;
    my %opts = @_;

    unless (exists $opts{'HTMLSetter'}) {
        $opts{'HTMLSetter'} ='/ajax/setter/booleanSetter.mas';
    }
    unless (exists $opts{'HTMLViewer'}) {
        $opts{'HTMLViewer'} ='/ajax/viewer/booleanInPlaceViewer.mas';
    }
    $opts{'type'} = 'boolean';

    my $self = $class->SUPER::new(%opts);
    bless($self, $class);
    return $self;
}

# Method: isEqualTo
#
# Overrides:
#
#       <EBox::Types::Abstract::isEqualTo>
#
sub isEqualTo
{
    my ($self, $other) = @_;

    return $self->cmp($other) == 0;

}

# Method: cmp
#
# Overrides:
#
#       <EBox::Types::Abstract::cmp>
#
sub cmp
{
    my ($self, $other) = @_;

    if ((ref $self) ne (ref $other)) {
        return undef;
    }

    my $ownValue = $self->value();
    my $otherValue = $other->value();

    if ($ownValue and (not $otherValue)) {
        return 1;
    }
    elsif ((not $ownValue) and $otherValue) {
        return -1;
    }
    else {
        # the two values are both true or false
        return 0;
    }
}

# Group: Protected methods

# Method: _setMemValue
#
# Overrides:
#
#       <EBox::Types::Abstract::_setMemValue>
#
sub _setMemValue
{
    my ($self, $params) = @_;

    $self->{'value'} = $params->{$self->fieldName()} ? 1 : 0;
}

# Method: _paramIsValid
#
# Overrides:
#
#       <EBox::Types::Abstract::_paramIsValid>
#
sub _paramIsValid
{
    my ($self, $params) = @_;

    return 1;
}

# Method: _paramIsSet
#
# Overrides:
#
#       <EBox::Types::Abstract::_paramIsSet>
#
sub _paramIsSet
{
    my ($self, $params) = @_;

    # Check if the parameter exist
    my $param =  $params->{$self->fieldName()};

    if (defined ($param)) {
        return 1;
    } else {
        if ($self->optional()) {
            return 0;
        } else {
            # We assume when the parameter is compulsory and it is not
            # in params, that the type value is false. This is a side
            # effect from HTTP protocol which does not send a value when
            # a checkbox is not checked
            return 1;
        }
    }
}

1;
