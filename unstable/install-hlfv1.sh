(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	$BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		    echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq!�_Ǿ (�ȗ�9�y�M���Z��:�����r���C�>���i7���`���2��q��)��+���������@�X�B`t%�2�f�_�S\.�$�J�e�B�߽�W쭣�r�h5���/���u������O�4Qɿ\���:�2�L��O��Q�A����P�أ���(IS_j�Oj�#��?����ʽ������]��]�<�l�%l��i��X�$l�sY��|�t|ԧ)��\��(�EQ�'����^������?E���q}����sؗRF�����Nl�jM�>��t��Xk��)R�.4Q�e$�e���$X`�{+X�R\�ʦ�m�0R�?����_5�
�B ��@���c%�&�'pG���&�OQ4�!
�\gu���=���p:�JH�w��L�	k[�ˋY�E�[�~dK��B]��:5VT��������4�m/�.]?]��1����0�Z�+%�������ď�����̟���)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Ny�NQ����������3� �
`��(��0�ݏ�N4@�U���7��x�깑�S8b	��+��+���B3	�\��{�p��[��Q��܂���@��5�?W'Nc9xkcŝ4�s�kf�7�n$m,lq�0�U�����\�O�"��$ͽ������Nip�3m�P<Q(tzSP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���=!98�ģȓ����/z^ .ԏ���4<�\XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋQW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����G��K���Q�S�U�G��?�T��e�5�g�;���@=2̛흺_���@�8��В��X>̐#q���^B�Џ��
|Hʑ�z E�����di���2s��I���:��2��4]�!�l��b��p��#v�D���[�NyM1GkH���5q"5q1u{����~o�yl��W�y.�V��
������2t����[���˶:U �U��ք9P�m�0<Z GZoi�rf�m qy���+ ���TɌ�\�A����}� ����堛��>�u�^��[��kSR�G�D������:��u�E��`f����d_��8�#�f5�7�~�&��� 7ؽߤی�	��97�~&׵d:\M�6��C%�u���|����]�������d�Q
>D�?s�����G�b�T�_*����+��ϵ~A��9&�r�/<B���2�K�������+U�O�����):�I#������8E�ů�4e�"����Q~�d�b4�z�W���](C���?��9����+����8؏;���p����.��g	}��@���p�����ֲ�۶̈ɸ!'MS�L���-eXO6C����c�}��t�Y�̱�1G[K|���n�,�F	�6Kٞ�U��{�K����*��|��?<���������j��Z�{������j�_9� �?J������+o�����o�Px$t�0�7[� -x�������]>tl�0�ެ���31��B���d�{*��< }d�ex�I&��T�[ӹg�6|�=̝�*"��"	s=����z���dް��1�?M�B�x��	����NV�;�g���5�H��q9#�����@~���-�A�%�S�q�s ��l(bK Ӑ���s'������m�2	\X�7h�y��磅iϞ�P���I`*����;����C���b��v�in��:K{��,�;�!/7;��
�(!�D��|$s�"yY��	���@N�b�Ak����S���������2�!�������KA��W����������k�����EЊ�K�%���_����(^�)��������\����P�-��E
R����K��cl���u(�p�v};@�Y�s��p�%Pa�a� !}�Y���*���C�<��	������*vE~�Z������֘.�m��H�n�����'/H���?�@�N�ǝ:���А�Q����2�F�	�6v�3�J������nO@�C���V>����3�pN)9��ͪ��w����S�O?�����&���r��O|�)��X��������}}�R�\�8AW��W�o_��.�?��h%�2��i;����Q�������a�+&��������2�)��p�Y�X�ql�t�b)��(�s	��l<!p�u<�Y�	ǷY���j��4�!���p�x�S�����`�����x�����	���m,� �r�+�5�D�|����j@.�l�uw�9��+>��z*�F��Qc&�:e^3�Z������p�i�a��3���}m�`�`f���ϻ�����������J��`��$���������'��ٗFU(e���=.�?���U��P
^��j�<���ϝ���k�KX0�}C~v��x���?K�ߟ����q����r1��Zo�H_������~�9���9���A��=zд�æ�[&N>��)��/��#݅����A?�$��}�؄q��1r-��f��Ex�p�LNp�ɬ'��x��bs5�9jo�EsI�٠��`�uF9��z��2<�Q&�=b��Mb����k�Mba΅�x|�s�[SW�e�"Ek�
?o@���P�r<����T���xl�A�Z�n�yP�:#���6\����`t�A�	NSΦ�4o���7�ڊlt��H�,�e�S����Ӷ7���{@��p��f�	zR.�do��l��-�U].��x�4������������q���K�oa�Sxe��M��������-Q��_�����$P�:���m�G�~�Ǹ0l�^�-��If�����l�G���?�e~��P~�(�|�n#�[�������<�Z�� 컦�Oܖ����yЃ!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4^;zz ��σ8��Х��cs �5�͑��hmւg�.��}{��Y#Yͥ.���d.���j�l��;�j��7|��N�aFHt��*�>=l<����O����� .������J�oa����?��?%�3�����A������?+���Q��W�������F���S`.��1����\.�˭�������,�W�_��������E=_�����\���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�W���V(C���?:������Rp����Lɖ�þeN�6;}�!Bs�m�me�E��#mѢ&/��1ќ��J;�����(���)�G�  �mow���c�o]�5�Oaz���z8#P�249�P�7�+u�Ŧ=4����^������Qg��>Z|�=~>��b�?=��@����J��O�B�����A��n���}�j5�F��Zm١��6�'~�𽰘����S�ʵ���"��k�����>}�_n�i�����\I�vU� ���n�]E��k�a�W�v���I����u��FH���ϿNi�������MjWn���uԎ�]׮����jE0]��W���<�������z>��ڕS;m��z���ծ�Sl��&���5|ɩn_�����\�ӥ��,���}sWT��nG���w����b���.����4DU�A�#�Q�����7����b��/��hv�oGپVT�;?��Z��u�i�]�>ʵ�(��ˍ���{��{�@���҂�?oA�%wۋ��M�7\G,��^d/?��-�D��n�Žyx��}�!?��S������Okӻ]��o��yU������{,���-��JcK����<N��ex�Mӯ58N�p'�zg����d�\*��������'��Ё�Q"?Rg5�|j��G�>���o�pD�=u���)��p,s�b໺x�7���]A�G"?0DCV�����-��eUqd|[��q��sF�ue���YNw_a�����)�n��ْ������Ƹn���r{;=��N]���6���[�q>���'�I��d��z�N��;�R	!	X��Ђ�GH�� ������Zv�V~ �N�I&�Lf:�-��Jw�=>~��~��s��ʙ�B���}x{��`��l�:���r��JH�<D
��T:E'b2_f;�Yc�\.����ƒQZۺv�@u�$�b��}ͦȤ�u�fZL�2�n�`�@��b^��ɼ<��-�9��CL��NWW]uUQ��!v��_�51\��@Pk�A.�ce2�aإ@���:bׄoX"�2r��P7�6�MU�����N3���%���)�g<��Ot�B���2,���NK�o��:�S���qμ	W�샙�f��9���9�XFBlQ���<���F�j_4�W���Bi5^�2V5Q;5���훳��)�b��{c��*yݢ�:@��S�,p�6����NKpJ�-��������OVwZ�h5�ή�������$]�uj�z�Q�Cx7�{�:�4:����9���u�M��Lڄŉ*>�z�����#���#
fOgt�|6܏/H@Y����x��x�P��J�DC��Y�)?�2meq��P����%��������3�3���E����u�&�i-P��Q���J|��oX7�{<KB�N_m�BK2��#x���\;���z�b6[�5F1���+�|�ȹ���>I���h�cI
ZG"b�L��e	��:� l��boKb�1���u�'�B69w�oK���>T�5������ӷ;[����:����w�t��j@?�}Z�C�y�(�{}���8�Oޠ�ƆǺ�W����xqs����?��������O�I�4(m]ع���?}�{w��U�Ɠ�X���<�S��ؾփ�1�~^�C�߷��=pT 5�'1�'����hz��շw_z�����������_n=��D~���pX����np�4�|ݍ��a ����|�x�y��5�א�][����'�Â��}v��� ^ܕ��ts��7��<0!瑃�,�ؼ0`���oR�$^뜴x�I���� BaFV�����C���a!� �v�U�һt�&RU����85��^�,�Խ��J]�]��:(��@V��A4�,],��8�k���}�6sK�d�$�Q$os��[���"����0*0�Va�h|@Ȇ8̲y6<�.1�*l�'g«d�1����R$�͏�Z���)K:�T��F3_0R�U)�j���zGJHi�ȣᴁJ)c���*��ň��=��i��Y�0dU+Ǒ��/_r���a�nE�|"��GL�e�E��ܦ�a�M=�)�5?��f����Ss#dݫG��F<���1/��Nz��P.��w��~Uh&Uth$1P�Ź0^(Ҹ�vZ�5О��r.J�[�h1�� ��!+͍{\�V3(�A� ��r<��)t	Y�/�N�,!+ً������dCu���U�b�ˍr5���@���O6�$�r��j��P��B=�N���~*Y�Ԓ�q��		.v�6����D�IY�l���,{��n�?�%�ZI�Q�x��Z��c	+�^rB'-�{�x��:�Z�%ʙ��f¥$#{�Z'c
UmT�}�t�Br
[4�
c��L0,��"��(�%e9"� �VY⺏��C<Ӕ�l�ī��A����y_4�fe��e4�������{XXgұF+��jqP����DJ
u�"��VY��e�BY��+Kse�㉁�1�W�8M{�<�R�<���؛�zc�]�/~4�eE�C��ң�/�{�nj\���dK8��Q,���PS��)KTN7��(F�q=TUA��2�l�*pؒ�^�]�,\d���8���Ɛ�*����Q�����SR��Oy��n	p�nK�Tzh�u�K)ŀ����X>-��6Jy}�r���,n�gs|6�g��g۹D�?Í��Kz�+��.��֝���\�/lݱsy�������G��e�>�g�2�g�����"_;UU;� o�]A6C�j��܏����=m�y\�t���Q��0B@���� j]RQ&'wP��BV4�z���a [sU�K�3b����&"��%p�P�q�{���cyryl?�̷���<�o�mw�U��֛0��}������"�4jVˑ�"�B�{��1W��m���ļ��)�+��up��4��
����1+V��)��A�� �����@��U �]V$}������D��?���y��6�ۇ�9/�K��/ϝ8tOL���Қ�Z�(��P������KJ�𠭎����h.:�Ok��xX���6]p�rd����κ��U��4�5gс<8�,DJLE�>���ޘ�UZ�2��}|L#b���\(+��VpLu�X<���0��h�/��R��Q��*E���t�MB%�,��5��Y��؃�a�If�d1A��2���19}3�Y����p�D4�j(��A��{��\||@�=�NjL�\�@s�D�#�@V,�	Ez@-������*�G}X��|�i����x82�x/$�AB
wd}�f0���P�vK��B���j4��8.5�� ��c����c�q���z��G��A��s��e��:&�9f>ӆ90۳{y
>8��^䲝���yX�=,����x�x�{[<,'��Ɖ�m:���#|����j�ԅ4o~~D,)����9,Py����6��A�YL�5(2k�E�5gY���0�ryg�����"�v��#tX�c���݌!�O�ZG���zBɪ֧�V�`�����qt4�h��Q0&!E��`��X8m0�0B���E��}��b���q߁��p����'U�w1\Ԇ����E���rU�zcR�)�~%S#Ӣ.U�1��R3�ǃ(��������!��-x ��ӢQmV
�~��&=�f���]�yc�1�8�ތ�Tޏw1ⷑS�=�S��c���F!��l;7��V�.�w�8oȍ����=��ӭh��_`�oN|{�$k5]4р�v�w��k�_��BIER�-�mA���\����ܨWY���M���"r��vso���ˏ�����z?����/~��{��^��s~r��ou���k�ws�bZ9Q���8��������9��ے�{��կ�׷�b�/���7�a���O&x�3����d�k�w�_D�=	��_L� xp�N�~hqE/wEc2��QCv���K~���������Cy�?�}�ŗ�����y�7x�A~� ���v�̍��H���C�t���ӡ	84���|�}��u�N@ڡv:�N����l���z�v��oy��7NA�܄W)3���M�m�@޶�:�x��s���31t���!~�:��5���8n��3p>�:�R��c�q�f<�3p$���d��zin��:O˙3�D[�93δ gZ�3g�1�8nÜ�3��=���13��y��NZ۔���Gϑ�y^�R�����Nr�����m�+�{v�  